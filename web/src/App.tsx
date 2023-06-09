import { useEffect, useState } from 'react'
import { emit } from './lib/nui'

import { PAGE_LIST } from './pages'
import { PERSISTENT_PAGES } from './persistent'
import { Box } from '@mantine/core'
import PageWrapper from './components/PageWrapper'

export default function App() {
    const [pages, setPages] = useState<string[]>([])
    const [hiddenPersistentPages, setHiddenPersistentPages] = useState<string[]>([])

    useEffect(() => {
        emit('ready')

        const handler = ({ data }: { data: { eventName: string; [key: string]: any } }) => {
            if (data.eventName === 'setPages') {
                setPages(data.pages)
            } else if (data.eventName === 'setHiddenPersistentPages') {
                setHiddenPersistentPages(data.hiddenPersistentPages)
            }
        }

        window.addEventListener('message', handler)
        return () => {
            window.removeEventListener('message', handler)
        }
    }, [])

    return (
        <Box sx={{ position: 'relative' }}>
            {pages.map((pageName: string) => {
                const Component = PAGE_LIST[pageName]
                if (!Component) return

                return (
                    <PageWrapper key={pageName}>
                        <Component />
                    </PageWrapper>
                )
            })}

            {Object.keys(PERSISTENT_PAGES).map((key) => {
                const Component = PERSISTENT_PAGES[key]
                return (
                    <div
                        style={{
                            position: 'absolute',
                            width: '100vw',
                            height: '100vh',
                            pointerEvents: 'none',
                            display: hiddenPersistentPages.includes(key) ? 'none' : 'block',
                        }}
                    >
                        <Component key={key} />
                    </div>
                )
            })}
        </Box>
    )
}
