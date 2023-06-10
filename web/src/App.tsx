import { useEffect, useState } from 'react'
import { emit } from './lib/nui'

import { PAGE_LIST } from './pages'
import { Box } from '@mantine/core'
import PageWrapper from './components/PageWrapper'

export default function App() {
    const [pages, setPages] = useState<string[]>([])

    useEffect(() => {
        emit('ready')

        const handler = ({ data }: { data: { eventName: string; [key: string]: any } }) => {
            if (data.eventName === 'setPages') {
                setPages(data.pages)
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
                    <PageWrapper key={pageName} pageName={pageName}>
                        <Component />
                    </PageWrapper>
                )
            })}
        </Box>
    )
}
