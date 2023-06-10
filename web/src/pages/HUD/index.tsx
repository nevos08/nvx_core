import { useEffect, useState } from 'react'
import { Box, Flex, Progress, Text, useMantineTheme } from '@mantine/core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

type HUDConfig = {
    EnableStatus: boolean
    EnableVehicle: boolean
}

type Status = {
    name: string
    value: number
    color: string
    icon: string
}

export default function HUD() {
    const theme = useMantineTheme()

    const [open, setOpen] = useState<boolean>(true)
    const [config, setConfig] = useState<HUDConfig>({ EnableStatus: true, EnableVehicle: true })
    const [status, setStatus] = useState<Status[]>([])

    useEffect(() => {
        const handler = ({ data }: INUIEvent) => {
            if (data.eventName == 'hud:toggle') {
                setOpen(data.state)
            } else if (data.eventName == 'hud:setConfig') {
                setConfig(data.config)
            } else if (data.eventName == 'hud:setStatus') {
                setStatus(data.status)
            }
        }

        window.addEventListener('message', handler)
        return () => window.removeEventListener('message', handler)
    }, [])

    return (
        <>
            {config.EnableStatus && (
                <Box
                    sx={{
                        position: 'absolute',
                        bottom: '40px',
                        right: '50px',
                        width: '300px',
                        padding: '5px 15px',
                        backgroundColor: theme.colors.dark[7],
                        borderRadius: theme.radius.sm,
                        boxShadow: theme.shadows.md,
                        border: '1px solid #3e3e3e',
                        display: open ? 'block' : 'none',
                        opacity: 0.85,
                    }}
                >
                    {status.length == 0 && <Text>No status found to show here.</Text>}
                    {status.map((status) => {
                        if (status.icon) {
                            return (
                                <Flex key={status.name} justify="space-between" align="center" gap="15px" my="5px">
                                    <Flex sx={{ flexGrow: 1, display: 'flex', justifyContent: 'center' }}>
                                        <FontAwesomeIcon
                                            icon={`fa-solid fa-${status.icon}` as any}
                                            size="lg"
                                            color={status.color}
                                            beat={status.value < 20.0}
                                        />
                                    </Flex>

                                    <Progress
                                        sx={{ marginBlock: '10px', flexBasis: '85%' }}
                                        size="md"
                                        value={status.value}
                                        color={status.color}
                                    />
                                </Flex>
                            )
                        }

                        return (
                            <Progress key={status.name} my="15px" size="md" value={status.value} color={status.color} />
                        )
                    })}
                </Box>
            )}
        </>
    )
}
