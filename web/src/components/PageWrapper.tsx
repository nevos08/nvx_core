import { Box } from '@mantine/core'
import { ReactNode, useEffect } from 'react'
import { emit } from '../lib/nui'

interface PageWrapperProps {
    pageName: string
    children: ReactNode
}

export default function PageWrapper({ pageName, children }: PageWrapperProps) {
    useEffect(() => {
        emit('pageReady', { pageName })
    }, [])
    return <Box sx={{ position: 'absolute', height: '100vh', width: '100vw' }}>{children}</Box>
}
