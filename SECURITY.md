# Politique de Sécurité VacanceIA

## 🛡️ Engagement Sécurité

La sécurité et la confidentialité de nos utilisateurs sont notre priorité absolue. Ce document détaille nos pratiques de sécurité et comment signaler des vulnérabilités.

## 🔐 Pratiques de Sécurité

### Chiffrement des Données

#### Données en Transit
- **TLS 1.3** pour toutes les communications
- **Certificate Pinning** sur l'application mobile
- **HSTS** activé sur tous les domaines

#### Données au Repos
- **AES-256-GCM** pour les données sensibles
- **Chiffrement de base de données** : PostgreSQL avec pgcrypto
- **Clés de chiffrement** : Rotation automatique tous les 90 jours

### Authentification & Autorisation

#### Multi-Factor Authentication (MFA)
- **TOTP** (Time-based One-Time Password)
- **WebAuthn** (clés de sécurité matérielles)
- **Biométrie** sur mobile (Face ID, Touch ID)

#### Gestion des Sessions
- **JWT** avec courte durée de vie (15 min)
- **Refresh tokens** sécurisés (httpOnly, secure cookies)
- **Révocation automatique** après 30 jours d'inactivité

#### Contrôle d'Accès
- **RBAC** (Role-Based Access Control)
- **Principe du moindre privilège**
- **Séparation des environnements** (dev/staging/prod)

### Protection des APIs

#### Rate Limiting
```python
# Limites par endpoint
AUTH_ENDPOINTS: 5 requêtes/minute
SEARCH_ENDPOINTS: 100 requêtes/minute
BOOKING_ENDPOINTS: 10 requêtes/minute
```

#### Validation des Entrées
- **Sanitization** de toutes les entrées utilisateur
- **Validation de schéma** avec Pydantic
- **Protection XSS** et injection SQL
- **Content Security Policy** (CSP) strict

#### API Keys
- **Rotation régulière** des clés API
- **Stockage sécurisé** dans HashiCorp Vault
- **Logs d'utilisation** pour audit

### Infrastructure

#### Containers & Orchestration
- **Images Docker** scannées (Trivy, Snyk)
- **Non-root containers** uniquement
- **Network policies** Kubernetes strictes
- **Secrets management** avec Sealed Secrets

#### Monitoring & Alertes
- **SIEM** pour détection d'intrusion
- **Alertes temps réel** sur activités suspectes
- **Logs centralisés** avec rétention 1 an
- **Dashboards sécurité** (Grafana)

### Conformité RGPD

#### Droits des Utilisateurs
- ✅ **Droit d'accès** : Export complet des données
- ✅ **Droit de rectification** : Modification self-service
- ✅ **Droit à l'effacement** : Suppression totale en 48h
- ✅ **Droit à la portabilité** : Export JSON/CSV
- ✅ **Droit d'opposition** : Opt-out du profilage IA

#### Privacy by Design
- **Minimisation des données** : Collecte strictement nécessaire
- **Anonymisation** : Données analytiques anonymisées
- **Pseudonymisation** : ID utilisateur dissocié des données sensibles
- **Consent management** : Consentement explicite et granulaire

#### DPO (Data Protection Officer)
- 📧 Email: dpo@vacanceia.io
- Réponse sous 72h maximum

## 🚨 Signalement de Vulnérabilités

### Programme de Bug Bounty

Nous encourageons la divulgation responsable des vulnérabilités.

#### Scope

**En Scope :**
- Application web (*.vacanceia.io)
- APIs publiques
- Application mobile (iOS/Android)
- Infrastructure publique

**Hors Scope :**
- Social engineering
- DoS/DDoS
- Spam
- Services tiers

#### Comment Signaler

1. **Email sécurisé** : security@vacanceia.io (PGP disponible)
2. **HackerOne** : hackerone.com/vacanceia
3. **GitHub Security Advisory** (pour ce repo)

**Informations à inclure :**
- Description de la vulnérabilité
- Étapes de reproduction
- Impact potentiel
- Preuve de concept (si applicable)

#### Processus de Traitement

1. **Accusé de réception** : Sous 24h
2. **Évaluation initiale** : Sous 48h
3. **Mise à jour régulière** : Toutes les 72h
4. **Résolution** : Selon sévérité
   - Critique : 24-48h
   - Haute : 7 jours
   - Moyenne : 30 jours
   - Basse : 90 jours

#### Récompenses

| Sévérité | Récompense |
|----------|------------|
| Critique | 1000€ - 5000€ |
| Haute | 500€ - 1000€ |
| Moyenne | 100€ - 500€ |
| Basse | 50€ - 100€ |

### Divulgation Responsable

**Nous nous engageons à :**
- Ne pas poursuivre en justice les chercheurs de bonne foi
- Reconnaître publiquement les découvreurs (avec leur accord)
- Travailler rapidement sur un correctif
- Tenir informé le découvreur du progrès

**Nous demandons :**
- **Confidentialité** jusqu'au correctif déployé
- **Pas d'exploitation** de la vulnérabilité
- **Pas d'accès** aux données d'autres utilisateurs
- **Pas de divulgation publique** prématurée

## 🔒 Bonnes Pratiques Utilisateurs

### Protégez Votre Compte

- ✅ Utilisez un **mot de passe unique et fort** (12+ caractères)
- ✅ Activez **l'authentification à deux facteurs** (MFA)
- ✅ Ne **partagez jamais** vos identifiants
- ✅ Vérifiez régulièrement l'**activité de votre compte**
- ✅ Déconnectez-vous sur les **appareils partagés**

### Phishing & Social Engineering

**VacanceIA ne vous demandera JAMAIS :**
- Votre mot de passe par email/téléphone
- Vos informations bancaires complètes
- De cliquer sur des liens suspects
- D'installer des logiciels tiers

**En cas de doute :**
- Vérifiez l'URL (https://vacanceia.io)
- Contactez le support officiel
- Ne cliquez pas sur les liens d'emails suspects

## 🏆 Certifications & Audits

### Certifications Visées

- [ ] **ISO 27001** (Sécurité de l'information)
- [ ] **SOC 2 Type II** (Contrôles sécurité)
- [ ] **PCI DSS** (Traitement paiements)
- [ ] **GDPR Compliance** (Protection données UE)

### Audits

- **Pentests** : Annuels (min.)
- **Code review** : Continu (automatisé + manuel)
- **Vulnerability scanning** : Hebdomadaire
- **Dependency audit** : Quotidien

## 📊 Métriques de Sécurité

Nous publions trimestriellement :
- Nombre de vulnérabilités découvertes/corrigées
- Temps moyen de résolution
- Incidents de sécurité (anonymisés)
- Améliorations apportées

## 📚 Ressources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [GDPR Official Text](https://gdpr.eu/)

## 🔄 Mises à Jour

Ce document est mis à jour régulièrement. Dernière révision : 2025-11-17

---

**Contact Sécurité** : security@vacanceia.io  
**PGP Key** : [Disponible sur keybase.io/vacanceia]

*La sécurité est un voyage, pas une destination.*
