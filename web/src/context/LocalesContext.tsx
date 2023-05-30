import { ReactNode, createContext, useContext, useEffect, useState } from 'react'

interface ILocalesContext {
    getLocales: (key: string) => string
}

const LocalesContext = createContext({})
export const useLocales = () => useContext(LocalesContext) as ILocalesContext

interface LocalesProviderProps {
    children: ReactNode
}

export default function LocalesProvider({ children }: LocalesProviderProps) {
    const [locales, setLocales] = useState<any>(null)

    const getLocales = (key: string) => {
        const local = locales[key]
        if (!local) return 'No locale provided.'
        return local
    }

    useEffect(() => {
        const handler = ({ data }: INUIEvent) => {
            if (data.eventName === 'setLocales') {
                console.log('got locales')
                setLocales(data.locales)
            }
        }

        window.addEventListener('message', handler)
        return () => {
            window.removeEventListener('message', handler)
        }
    }, [])

    return <LocalesContext.Provider value={{ getLocales }}>{children}</LocalesContext.Provider>
}
