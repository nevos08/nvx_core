import { useEffect } from 'react'
import { emit } from './lib/nui'

export default function App() {
    useEffect(() => {
        emit('ready')
    }, [])
    return <></>
}
