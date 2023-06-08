import { Box } from '@mantine/core'
import { ReactNode } from 'react'

interface PageWrapperProps {
    children: ReactNode
}

export default function PageWrapper({ children }: PageWrapperProps) {
    return <Box sx={{ position: 'absolute', height: '100vh', width: '100vw' }}>{children}</Box>
}
