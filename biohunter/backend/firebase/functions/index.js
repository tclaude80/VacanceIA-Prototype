const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');

admin.initializeApp();
const db = admin.firestore();

const app = express();
app.use(cors({ origin: true }));

// ==================== SCORE API ====================

/**
 * POST /score
 * Enregistre le score d'un joueur après une session de quiz
 */
app.post('/score', async (req, res) => {
  try {
    const { userId, score, sessionData } = req.body;

    if (!userId || !score) {
      return res.status(400).json({ error: 'userId and score are required' });
    }

    // Enregistrer la session de jeu
    const sessionRef = await db.collection('GameSessions').add({
      userId,
      score,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      ...sessionData
    });

    // Mettre à jour les stats utilisateur
    const userRef = db.collection('Users').doc(userId);
    await userRef.update({
      totalScore: admin.firestore.FieldValue.increment(score),
      gamesPlayed: admin.firestore.FieldValue.increment(1),
      lastPlayedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    // Mettre à jour le leaderboard
    await updateLeaderboard(userId, score);

    res.json({
      success: true,
      sessionId: sessionRef.id,
      message: 'Score enregistré avec succès'
    });
  } catch (error) {
    console.error('Error saving score:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ==================== LEADERBOARD API ====================

/**
 * GET /leaderboard
 * Récupère le classement des joueurs
 */
app.get('/leaderboard', async (req, res) => {
  try {
    const { type = 'global', limit = 100, userId } = req.query;

    let query = db.collection('Leaderboards')
      .doc(type)
      .collection('rankings')
      .orderBy('score', 'desc')
      .limit(parseInt(limit));

    const snapshot = await query.get();
    const leaderboard = snapshot.docs.map((doc, index) => ({
      rank: index + 1,
      ...doc.data()
    }));

    // Si userId fourni, trouver sa position
    let userRank = null;
    if (userId) {
      userRank = await getUserRank(userId, type);
    }

    res.json({
      success: true,
      leaderboard,
      userRank
    });
  } catch (error) {
    console.error('Error fetching leaderboard:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ==================== GACHA SYSTEM ====================

/**
 * POST /gacha-pull
 * Effectue un tirage gacha pour le joueur
 */
app.post('/gacha-pull', async (req, res) => {
  try {
    const { userId } = req.body;

    if (!userId) {
      return res.status(400).json({ error: 'userId is required' });
    }

    // Vérifier les bio-coins du joueur
    const userDoc = await db.collection('Users').doc(userId).get();
    const userData = userDoc.data();

    if (!userData || userData.bioCoins < 100) {
      return res.status(400).json({ error: 'Insufficient bio-coins' });
    }

    // Effectuer le tirage
    const reward = performGachaPull();

    // Déduire les coins et ajouter la récompense
    await db.collection('Users').doc(userId).update({
      bioCoins: admin.firestore.FieldValue.increment(-100),
      [`rewards.${reward.type}`]: admin.firestore.FieldValue.arrayUnion(reward.id)
    });

    res.json({
      success: true,
      reward
    });
  } catch (error) {
    console.error('Error performing gacha pull:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ==================== DAILY MICROSCOPE ====================

/**
 * GET /daily-microscope
 * Récupère la question microscopique du jour
 */
app.get('/daily-microscope', async (req, res) => {
  try {
    const { userId } = req.query;
    const today = new Date().toISOString().split('T')[0];

    // Récupérer la question du jour
    const dailyDoc = await db.collection('DailyMicroscope').doc(today).get();

    if (!dailyDoc.exists) {
      // Générer une nouvelle question du jour
      const question = await generateDailyQuestion();
      await db.collection('DailyMicroscope').doc(today).set(question);

      res.json({ success: true, question });
    } else {
      const question = dailyDoc.data();

      // Vérifier si l'utilisateur a déjà répondu
      let hasAnswered = false;
      if (userId) {
        const answerDoc = await db.collection('DailyAnswers')
          .where('userId', '==', userId)
          .where('date', '==', today)
          .get();
        hasAnswered = !answerDoc.empty;
      }

      res.json({
        success: true,
        question,
        hasAnswered
      });
    }
  } catch (error) {
    console.error('Error fetching daily microscope:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// ==================== HELPER FUNCTIONS ====================

async function updateLeaderboard(userId, score) {
  const userDoc = await db.collection('Users').doc(userId).get();
  const userData = userDoc.data();

  // Global leaderboard
  await db.collection('Leaderboards')
    .doc('global')
    .collection('rankings')
    .doc(userId)
    .set({
      userId,
      username: userData.username,
      score: userData.totalScore,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });
}

async function getUserRank(userId, type) {
  const userDoc = await db.collection('Leaderboards')
    .doc(type)
    .collection('rankings')
    .doc(userId)
    .get();

  if (!userDoc.exists) return null;

  const userScore = userDoc.data().score;
  const snapshot = await db.collection('Leaderboards')
    .doc(type)
    .collection('rankings')
    .where('score', '>', userScore)
    .get();

  return snapshot.size + 1;
}

function performGachaPull() {
  const random = Math.random();

  // Probabilités: Commun 70%, Rare 25%, Légendaire 5%
  if (random < 0.70) {
    return { type: 'skin', rarity: 'common', id: `skin_common_${Date.now()}` };
  } else if (random < 0.95) {
    return { type: 'skin', rarity: 'rare', id: `skin_rare_${Date.now()}` };
  } else {
    return { type: 'skin', rarity: 'legendary', id: `skin_legendary_${Date.now()}` };
  }
}

async function generateDailyQuestion() {
  // Sélectionner une question aléatoire de la base
  const questionsSnapshot = await db.collection('Questions')
    .where('difficulty', '==', 'daily')
    .limit(10)
    .get();

  const questions = questionsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
  const randomQuestion = questions[Math.floor(Math.random() * questions.length)];

  return {
    questionId: randomQuestion.id,
    date: new Date().toISOString().split('T')[0],
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  };
}

// ==================== EXPORT FUNCTIONS ====================

exports.api = functions.https.onRequest(app);

// Scheduled function pour nettoyer les anciennes sessions
exports.cleanupOldSessions = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const snapshot = await db.collection('GameSessions')
      .where('timestamp', '<', thirtyDaysAgo)
      .get();

    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
      batch.delete(doc.ref);
    });

    await batch.commit();
    console.log(`Cleaned up ${snapshot.size} old sessions`);
    return null;
  });

// Trigger pour mettre à jour les achievements
exports.checkAchievements = functions.firestore
  .document('GameSessions/{sessionId}')
  .onCreate(async (snap, context) => {
    const session = snap.data();
    const userId = session.userId;

    const userRef = db.collection('Users').doc(userId);
    const userDoc = await userRef.get();
    const userData = userDoc.data();

    const achievements = [];

    // Vérifier différents achievements
    if (userData.gamesPlayed === 10) {
      achievements.push('first_10_games');
    }
    if (userData.gamesPlayed === 100) {
      achievements.push('century_player');
    }
    if (userData.totalScore >= 10000) {
      achievements.push('score_master');
    }

    if (achievements.length > 0) {
      await userRef.update({
        achievements: admin.firestore.FieldValue.arrayUnion(...achievements)
      });
    }

    return null;
  });
