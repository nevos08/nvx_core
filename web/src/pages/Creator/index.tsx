import { Box, Button, Center, Group, NumberInput, Radio, TextInput, Title, useMantineTheme } from '@mantine/core'
import { useForm } from '@mantine/form'
import { DatePickerInput } from '@mantine/dates'
import { useLocales } from '../../context/LocalesContext'
import { emit } from '../../lib/nui'

export default function Creator() {
    const theme = useMantineTheme()
    const { locales } = useLocales()

    const form = useForm({
        initialValues: {
            firstName: '',
            lastName: '',
            dob: new Date('1990-01-01'),
            height: 180,
            nationality: 'United States',
            sex: 'male',
        },
        validate: {
            firstName: (value) => {
                if (!value || value.length < 3 || value.length > 25) {
                    return locales.Creator?.firstNameInvalid || 'Der Vorname muss zwischen 3 und 25 Zeichen lang sein.'
                }

                return
            },
            lastName: (value) => {
                if (!value || value.length < 3 || value.length > 25) {
                    return locales.Creator?.lastNameInvalid || 'Der Nachname muss zwischen 3 und 25 Zeichen lang sein.'
                }

                return
            },
            height: (value) => {
                if (!value || value < 150 || value > 220) {
                    return locales.Creator?.heightInvalid || 'Deine Körpergröße muss zwischen 150 und 220 liegen.'
                }

                return
            },
            nationality: (value) => {
                if (!value || value.length < 3) {
                    return locales.Creator?.nationalityInvalid || 'Deine Nationalität ist ungültig.'
                }

                return
            },
        },
    })

    return (
        <Center sx={{ height: '100%' }}>
            <Box
                sx={{
                    minWidth: '500px',
                    padding: '10px 20px',
                    paddingBottom: '15px',
                    backgroundColor: theme.colors.dark[7],
                    borderRadius: theme.radius.sm,
                    boxShadow: theme.shadows.lg,
                    border: '1px solid #3e3e3e',
                }}
            >
                <Title
                    sx={{
                        color: 'white',
                        textAlign: 'center',
                        fontFamily: 'Jaldi',
                    }}
                >
                    {locales.Creator?.title || 'Charakter erstellen'}
                </Title>

                <form
                    onSubmit={form.onSubmit((values) => {
                        emit('creator:submit', { ...values })
                    })}
                >
                    <TextInput
                        withAsterisk
                        mt="10px"
                        size="md"
                        label={locales.Creator?.firstName || 'Vorname'}
                        {...form.getInputProps('firstName')}
                    />

                    <TextInput
                        withAsterisk
                        mt="10px"
                        size="md"
                        label={locales.Creator?.lastName || 'Nachname'}
                        {...form.getInputProps('lastName')}
                    />

                    <DatePickerInput
                        withAsterisk
                        mt="10px"
                        size="md"
                        label={locales.Creator?.dob || 'Geburtsdatum'}
                        valueFormat="DD.MM.YYYY"
                        minDate={new Date('1930-01-01')}
                        maxDate={new Date('2008-12-31')}
                        {...form.getInputProps('dob')}
                    />

                    <NumberInput
                        withAsterisk
                        mt="10px"
                        size="md"
                        label={locales.Creator?.height || 'Körpergröße'}
                        {...form.getInputProps('height')}
                    />

                    <TextInput
                        withAsterisk
                        mt="10px"
                        size="md"
                        label={locales.Creator?.nationality || 'Nationalität'}
                        {...form.getInputProps('nationality')}
                    />

                    <Radio.Group
                        mt="10px"
                        withAsterisk
                        size="md"
                        name="sex"
                        label={locales.Creator?.sex || 'Geschlecht'}
                        {...form.getInputProps('sex')}
                    >
                        <Group mt="5px">
                            <Radio value="male" label={locales.Creator?.male || 'Männlich'} />
                            <Radio value="female" label={locales.Creator?.female || 'Weiblich'} />
                        </Group>
                    </Radio.Group>

                    <Button variant="light" size="md" fullWidth sx={{ marginTop: '15px' }} type="submit">
                        {locales.Creator?.submit || 'Bestätigen'}
                    </Button>
                </form>
            </Box>
        </Center>
    )
}
