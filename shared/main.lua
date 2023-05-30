Shared = {}

Shared.Locales = json.decode(LoadResourceFile("nvx_core", "locales/" .. Config.Locales .. ".json"))
if not Shared.Locales then
    print("[NVX Core] Invalid locale provided.")
end
