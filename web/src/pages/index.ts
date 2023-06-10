import { FC } from 'react'

import Multicharacter from './Multicharacter'
import Creator from './Creator'
import HUD from './HUD'

export const PAGE_LIST: Record<string, FC> = { Multicharacter, Creator, HUD }
