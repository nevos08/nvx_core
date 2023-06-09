import { Box, Button, Center, Title, useMantineTheme } from '@mantine/core'
import { useEffect, useState } from 'react'
import { useLocales } from '../../context/LocalesContext'
import { emit } from '../../lib/nui'

type Character = {
    uuid: string
    name: string
}

export default function Multicharacter() {
    const theme = useMantineTheme()
    const { locales } = useLocales()

    const [characters, setCharacters] = useState<Character[]>([])
    const [slots, setSlots] = useState<number>(2)

    const onCreate = () => {
        emit('multicharacter:create')
    }

    useEffect(() => {
        emit('pageReady', { pageName: 'Multicharacter' })

        const handler = ({ data }: { data: { eventName: string; [key: string]: any } }) => {
            if (data.eventName == 'setData') {
                setCharacters(data.characters)
                setSlots(data.slots)
            } else if (data.eventName == 'setCharacters') {
                setCharacters(data.characters)
            } else if (data.eventName == 'setSlots') {
                setSlots(data.slots)
            }
        }

        window.addEventListener('message', handler)
        return () => {
            window.removeEventListener('message', handler)
        }
    }, [])

    return (
        <Center sx={{ height: '100%', width: 'fit-content' }}>
            <Box
                sx={(theme) => ({
                    minWidth: '400px',
                    marginLeft: '50px',
                    padding: '10px 20px',
                    paddingBottom: '15px',
                    backgroundColor: '#1a1a1a',
                    borderRadius: theme.radius.sm,
                    boxShadow: theme.shadows.lg,
                    border: `1px solid #3e3e3e`,
                })}
            >
                <Title sx={{ color: 'white', textAlign: 'center', fontFamily: 'Jaldi' }}>
                    {locales.Multicharacter?.title || 'Charakter wählen'}
                </Title>

                <Box my="5px">
                    {characters.length > 0 ? (
                        characters.map((character) => <Character uuid={character.uuid} name={character.name} />)
                    ) : (
                        <Center
                            sx={{
                                width: '100%',
                                padding: '10px 20px',
                                backgroundColor: '#2e2e2e',
                                borderRadius: theme.radius.sm,
                                color: 'white',
                                textAlign: 'center',
                            }}
                        >
                            {locales.Multicharacter?.noCharacters || 'Keine Charaktere gefunden.'}
                        </Center>
                    )}
                </Box>

                {characters.length < slots && (
                    <Button
                        variant="light"
                        sx={{ width: '100%', marginTop: '5px', transition: '.2s' }}
                        size="md"
                        onClick={onCreate}
                    >
                        {locales.Multicharacter?.createButton || 'Charakter erstellen'}
                    </Button>
                )}
            </Box>
        </Center>
    )
}

function Character({ uuid, name }: Character) {
    const theme = useMantineTheme()

    const onMouseEnter = () => {
        emit('multicharacter:previewCharacter', { uuid })
    }

    const onClick = () => {
        emit('multicharacter:chooseCharacter', { uuid })
    }

    return (
        <Box
            sx={{
                width: '100%',
                padding: '10px 20px',
                backgroundColor: '#2e2e2e',
                border: '1px solid #3e3e3e',
                borderRadius: theme.radius.sm,
                color: 'white',
                textAlign: 'center',
                transition: '.2s',
                cursor: 'pointer',
                [':hover']: {
                    backgroundColor: theme.colors.blue[7],
                },
            }}
            onMouseEnter={onMouseEnter}
            onClick={onClick}
        >
            {name}
        </Box>
    )
}
