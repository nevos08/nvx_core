Shared.Math = {}

---Rounds a number to its specified decimalPoints
---Credits: es_extended
---@param value number
---@param decimalPoints number
---@return number
function Shared.Math.Round(value, decimalPoints)
    if not decimalPoints then
        decimalPoints = 2
    end

    local power = 10 ^ decimalPoints
    return math.floor(((value * power) + 0.5) / (power))
end
