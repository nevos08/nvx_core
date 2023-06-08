import React from 'react'
import ReactDOM from 'react-dom/client'
import { MantineProvider } from '@mantine/core'

import App from './App.tsx'
import './styles/index.css'
import LocalesProvider from './context/LocalesContext.tsx'

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
    <React.StrictMode>
        <MantineProvider
            withGlobalStyles
            withNormalizeCSS
            theme={{
                colorScheme: 'dark',
                fontFamily: 'Source Sans Pro',
            }}
        >
            <LocalesProvider>
                <App />
            </LocalesProvider>
        </MantineProvider>
    </React.StrictMode>
)
