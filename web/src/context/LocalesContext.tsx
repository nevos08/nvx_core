import { ReactNode, createContext, useContext, useEffect, useState } from 'react'

interface ILocalesContext {
    locales: any
}

const LocalesContext = createContext({})
export const useLocales = () => useContext(LocalesContext) as ILocalesContext

interface LocalesProviderProps {
    children: ReactNode
}

export default function LocalesProvider({ children }: LocalesProviderProps) {
    const [locales, setLocales] = useState<any>({})

    useEffect(() => {
        const handler = ({ data }: INUIEvent) => {
            if (data.eventName === 'setLocales') {
                setLocales(data.locales)
            }
        }

        window.addEventListener('message', handler)
        return () => {
            window.removeEventListener('message', handler)
        }
    }, [])

    return <LocalesContext.Provider value={{ locales }}>{children}</LocalesContext.Provider>
}
