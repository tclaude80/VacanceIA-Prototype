import { User, Settings, Shield, Download } from 'lucide-react'

const Profile = () => {
  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-white rounded-2xl shadow-lg p-8 border border-gray-100">
        <div className="flex items-center space-x-4 mb-8">
          <div className="h-20 w-20 bg-primary-100 rounded-full flex items-center justify-center">
            <User className="h-10 w-10 text-primary-600" />
          </div>
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Mon Profil</h1>
            <p className="text-gray-600">Voyageur VacanceIA</p>
          </div>
        </div>

        {/* Profile Sections */}
        <div className="space-y-6">
          {/* Personal Info */}
          <section className="border-b border-gray-200 pb-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-4 flex items-center">
              <Settings className="mr-2 h-5 w-5" />
              Informations personnelles
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Nom complet</label>
                <input
                  type="text"
                  placeholder="Votre nom"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Email</label>
                <input
                  type="email"
                  placeholder="email@exemple.com"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
                />
              </div>
            </div>
          </section>

          {/* Travel Preferences */}
          <section className="border-b border-gray-200 pb-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">
              Préférences de voyage
            </h2>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Style de voyage</label>
                <select className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500">
                  <option>Modéré</option>
                  <option>Relaxé</option>
                  <option>Intense</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Gamme de budget</label>
                <select className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500">
                  <option>Économique</option>
                  <option>Moyen</option>
                  <option>Élevé</option>
                  <option>Luxe</option>
                </select>
              </div>
            </div>
          </section>

          {/* Privacy & Security */}
          <section className="border-b border-gray-200 pb-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-4 flex items-center">
              <Shield className="mr-2 h-5 w-5" />
              Confidentialité & Sécurité
            </h2>
            <div className="space-y-3">
              <label className="flex items-center space-x-3">
                <input type="checkbox" className="rounded border-gray-300" defaultChecked />
                <span className="text-sm text-gray-700">Authentification à deux facteurs activée</span>
              </label>
              <label className="flex items-center space-x-3">
                <input type="checkbox" className="rounded border-gray-300" defaultChecked />
                <span className="text-sm text-gray-700">Notifications de sécurité</span>
              </label>
            </div>
          </section>

          {/* GDPR Compliance */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-4">
              Vos données (RGPD)
            </h2>
            <div className="space-y-3">
              <button className="flex items-center text-primary-600 hover:text-primary-700 font-medium">
                <Download className="mr-2 h-4 w-4" />
                Télécharger mes données
              </button>
              <button className="flex items-center text-red-600 hover:text-red-700 font-medium">
                Supprimer mon compte
              </button>
            </div>
          </section>
        </div>

        {/* Save Button */}
        <div className="mt-8">
          <button className="w-full bg-primary-600 text-white py-3 rounded-lg font-semibold hover:bg-primary-700 transition-colors">
            Enregistrer les modifications
          </button>
        </div>
      </div>
    </div>
  )
}

export default Profile
