import { ReactNode } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { Plane, Search, Calendar, User, Shield } from 'lucide-react'

interface LayoutProps {
  children: ReactNode
}

const Layout = ({ children }: LayoutProps) => {
  const location = useLocation()

  const navigation = [
    { name: 'Accueil', href: '/', icon: Plane },
    { name: 'Recherche', href: '/search', icon: Search },
    { name: 'Mon Itinéraire', href: '/itinerary', icon: Calendar },
    { name: 'Profil', href: '/profile', icon: User },
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-teal-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            {/* Logo */}
            <Link to="/" className="flex items-center space-x-2">
              <Plane className="h-8 w-8 text-primary-600" />
              <span className="text-2xl font-bold text-gray-900">VacanceIA</span>
            </Link>

            {/* Navigation */}
            <nav className="hidden md:flex space-x-8">
              {navigation.map((item) => {
                const Icon = item.icon
                const isActive = location.pathname === item.href
                return (
                  <Link
                    key={item.name}
                    to={item.href}
                    className={`flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                      isActive
                        ? 'text-primary-600 bg-primary-50'
                        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                    }`}
                  >
                    <Icon className="h-4 w-4" />
                    <span>{item.name}</span>
                  </Link>
                )
              })}
            </nav>

            {/* Security Badge */}
            <div className="flex items-center space-x-2 text-sm text-gray-600">
              <Shield className="h-4 w-4 text-green-600" />
              <span className="hidden sm:inline">Sécurisé</span>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {children}
      </main>

      {/* Footer */}
      <footer className="bg-gray-900 text-white mt-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div>
              <h3 className="text-lg font-semibold mb-4">VacanceIA</h3>
              <p className="text-gray-400 text-sm">
                Assistant IA éthique pour l'organisation de voyages.
                Voyagez intelligent, voyagez responsable.
              </p>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Sécurité & Éthique</h3>
              <ul className="space-y-2 text-sm text-gray-400">
                <li>✓ Chiffrement bout-en-bout</li>
                <li>✓ Conformité RGPD</li>
                <li>✓ IA transparente et explicable</li>
                <li>✓ Protection des données personnelles</li>
              </ul>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Contact</h3>
              <ul className="space-y-2 text-sm text-gray-400">
                <li>Email: support@vacanceia.io</li>
                <li>GitHub: @tclaude80</li>
                <li>Twitter: @tclaude80</li>
              </ul>
            </div>
          </div>
          <div className="mt-8 pt-8 border-t border-gray-800 text-center text-sm text-gray-400">
            <p>&copy; 2025 VacanceIA. Tous droits réservés. | MIT License</p>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default Layout
