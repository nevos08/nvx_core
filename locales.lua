Locales = json.decode(LoadResourceFile("nvx_core", "locales/" .. Config.Locales .. ".json"))
if not Locales then
    print("[NVX Core] Invalid locale provided.")
end
