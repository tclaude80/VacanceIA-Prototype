import { useState } from 'react'
import { Calendar, MapPin, Clock } from 'lucide-react'
const Itinerary = () => {
  const [formData, setFormData] = useState({
    destination: '',
    duration: 5,
    interests: [] as string[],
    pace: 'moderate',
  })

  const interestOptions = [
    'Culture', 'Histoire', 'Gastronomie', 'Nature',
    'Aventure', 'Plage', 'Shopping', 'Vie nocturne',
  ]

  const toggleInterest = (interest: string) => {
    setFormData(prev => ({
      ...prev,
      interests: prev.interests.includes(interest)
        ? prev.interests.filter(i => i !== interest)
        : [...prev.interests, interest]
    }))
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    console.log('Generating itinerary:', formData)
  }

  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-white rounded-2xl shadow-lg p-8 border border-gray-100">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Créer un itinéraire personnalisé
        </h1>
        <p className="text-gray-600 mb-8">
          L'IA génèrera un planning jour par jour adapté à vos intérêts.
        </p>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Destination */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <MapPin className="inline h-4 w-4 mr-1" />
              Destination
            </label>
            <input
              type="text"
              value={formData.destination}
              onChange={(e) => setFormData({ ...formData, destination: e.target.value })}
              placeholder="Kyoto, Marrakech, Rome..."
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
              required
            />
          </div>

          {/* Duration */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <Calendar className="inline h-4 w-4 mr-1" />
              Durée du séjour (jours)
            </label>
            <input
              type="number"
              min="1"
              max="30"
              value={formData.duration}
              onChange={(e) => setFormData({ ...formData, duration: parseInt(e.target.value) })}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
          </div>

          {/* Interests */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-3">
              Centres d'intérêt
            </label>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              {interestOptions.map((interest) => (
                <button
                  key={interest}
                  type="button"
                  onClick={() => toggleInterest(interest)}
                  className={`px-4 py-2 rounded-lg border-2 transition-colors ${
                    formData.interests.includes(interest)
                      ? 'bg-primary-600 border-primary-600 text-white'
                      : 'bg-white border-gray-300 text-gray-700 hover:border-primary-300'
                  }`}
                >
                  {interest}
                </button>
              ))}
            </div>
          </div>

          {/* Pace */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-3">
              <Clock className="inline h-4 w-4 mr-1" />
              Rythme de voyage
            </label>
            <div className="grid grid-cols-3 gap-3">
              {['relaxed', 'moderate', 'packed'].map((pace) => (
                <button
                  key={pace}
                  type="button"
                  onClick={() => setFormData({ ...formData, pace })}
                  className={`px-4 py-3 rounded-lg border-2 transition-colors capitalize ${
                    formData.pace === pace
                      ? 'bg-primary-600 border-primary-600 text-white'
                      : 'bg-white border-gray-300 text-gray-700 hover:border-primary-300'
                  }`}
                >
                  {pace === 'relaxed' ? 'Relaxé' : pace === 'moderate' ? 'Modéré' : 'Intense'}
                </button>
              ))}
            </div>
          </div>

          {/* Submit */}
          <button
            type="submit"
            className="w-full bg-primary-600 text-white py-4 rounded-lg font-semibold hover:bg-primary-700 transition-colors shadow-lg hover:shadow-xl"
          >
            Générer l'itinéraire avec l'IA
          </button>
        </form>
      </div>

      {/* Preview Section */}
      <div className="mt-6 bg-gradient-to-r from-purple-50 to-pink-50 rounded-lg p-6 border border-purple-100">
        <h3 className="font-semibold text-purple-900 mb-2">🧠 IA Itinéraire Agent</h3>
        <p className="text-sm text-purple-800">
          Notre agent IA créera un planning détaillé incluant :<br />
          • Activités adaptées à vos centres d'intérêt<br />
          • Recommandations de restaurants locaux<br />
          • Optimisation des déplacements<br />
          • Conseils pratiques et astuces locales
        </p>
      </div>
    </div>
  )
}

export default Itinerary
