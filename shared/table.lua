Shared.Table = {}

function Shared.Table.Print(table)
    local function DumpTable(table, nb)
        if nb == nil then
            nb = 0
        end

        if type(table) == 'table' then
            local s = ''
            for i = 1, nb + 1, 1 do
                s = s .. "    "
            end

            s = '{\n'
            for k, v in pairs(table) do
                if type(k) ~= 'number' then k = '"' .. k .. '"' end
                for i = 1, nb, 1 do
                    s = s .. "    "
                end
                s = s .. '[' .. k .. '] = ' .. DumpTable(v, nb + 1) .. ',\n'
            end

            for i = 1, nb, 1 do
                s = s .. "    "
            end

            return s .. '}'
        else
            return tostring(table)
        end
    end

    print(DumpTable(table))
end
