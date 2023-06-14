import React from 'react'
import ReactDOM from 'react-dom/client'
import { MantineProvider } from '@mantine/core'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'

import App from './App.tsx'
import './styles/index.css'
import LocalesProvider from './context/LocalesContext.tsx'

library.add(fas)

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
    <React.StrictMode>
        <MantineProvider
            withGlobalStyles
            withNormalizeCSS
            theme={{
                colorScheme: 'dark',
                fontFamily: 'Source Sans Pro',
                primaryColor: 'teal',
            }}
        >
            <LocalesProvider>
                <App />
            </LocalesProvider>
        </MantineProvider>
    </React.StrictMode>
)
