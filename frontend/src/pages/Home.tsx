import { Link } from 'react-router-dom'
import { Search, Calendar, Shield, Sparkles, Globe, Heart } from 'lucide-react'

const Home = () => {
  const features = [
    {
      icon: Sparkles,
      title: 'IA Personnalisée',
      description: 'Recommandations adaptées à vos préférences et votre style de voyage',
    },
    {
      icon: Shield,
      title: 'Sécurité Maximale',
      description: 'Chiffrement bout-en-bout et conformité RGPD garantie',
    },
    {
      icon: Globe,
      title: 'Recherche Globale',
      description: 'Accès à des millions d\'options de vols, hôtels et activités',
    },
    {
      icon: Heart,
      title: 'Tourisme Responsable',
      description: 'Options écologiques et soutien aux communautés locales',
    },
  ]

  return (
    <div className="space-y-16">
      {/* Hero Section */}
      <section className="text-center space-y-6 py-12">
        <h1 className="text-5xl md:text-6xl font-bold text-gray-900">
          Voyagez avec l'<span className="text-primary-600">Intelligence Artificielle</span>
        </h1>
        <p className="text-xl text-gray-600 max-w-2xl mx-auto">
          VacanceIA utilise l'IA éthique pour créer des expériences de voyage
          personnalisées, sécurisées et responsables.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center items-center pt-4">
          <Link
            to="/search"
            className="inline-flex items-center px-8 py-4 bg-primary-600 text-white rounded-lg font-semibold hover:bg-primary-700 transition-colors shadow-lg hover:shadow-xl"
          >
            <Search className="mr-2 h-5 w-5" />
            Commencer ma recherche
          </Link>
          <Link
            to="/itinerary"
            className="inline-flex items-center px-8 py-4 bg-white text-gray-900 rounded-lg font-semibold hover:bg-gray-50 transition-colors border-2 border-gray-200"
          >
            <Calendar className="mr-2 h-5 w-5" />
            Créer un itinéraire
          </Link>
        </div>
      </section>

      {/* Features Grid */}
      <section className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {features.map((feature) => {
          const Icon = feature.icon
          return (
            <div
              key={feature.title}
              className="bg-white rounded-xl p-8 shadow-md hover:shadow-lg transition-shadow border border-gray-100"
            >
              <div className="flex items-start space-x-4">
                <div className="bg-primary-100 p-3 rounded-lg">
                  <Icon className="h-6 w-6 text-primary-600" />
                </div>
                <div className="flex-1">
                  <h3 className="text-xl font-semibold text-gray-900 mb-2">
                    {feature.title}
                  </h3>
                  <p className="text-gray-600">{feature.description}</p>
                </div>
              </div>
            </div>
          )
        })}
      </section>

      {/* Stats Section */}
      <section className="bg-gradient-to-r from-primary-600 to-teal-600 rounded-2xl p-12 text-white">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
          <div>
            <div className="text-4xl font-bold mb-2">100%</div>
            <div className="text-primary-100">Conforme RGPD</div>
          </div>
          <div>
            <div className="text-4xl font-bold mb-2">256-bit</div>
            <div className="text-primary-100">Chiffrement AES</div>
          </div>
          <div>
            <div className="text-4xl font-bold mb-2">24/7</div>
            <div className="text-primary-100">Support disponible</div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-white rounded-2xl p-12 text-center shadow-md border border-gray-100">
        <h2 className="text-3xl font-bold text-gray-900 mb-4">
          Prêt à planifier votre prochaine aventure ?
        </h2>
        <p className="text-gray-600 mb-8 max-w-2xl mx-auto">
          Rejoignez des milliers de voyageurs qui font confiance à VacanceIA
          pour organiser leurs voyages en toute sécurité.
        </p>
        <Link
          to="/search"
          className="inline-flex items-center px-8 py-4 bg-primary-600 text-white rounded-lg font-semibold hover:bg-primary-700 transition-colors shadow-lg hover:shadow-xl"
        >
          Démarrer maintenant
        </Link>
      </section>
    </div>
  )
}

export default Home
