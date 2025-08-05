# React Settings Synchronization

Pattern for syncing React state with Obsidian plugin settings.

## Pattern
```typescript
const MySettingsComponent: FC<ComponentProps> = ({ settings, plugin }) => {
    const [localValue, setLocalValue] = useState(settings.myValue);
    
    const updateSetting = async (newValue: string) => {
        setLocalValue(newValue);
        settings.myValue = newValue;
        await plugin.saveSettings();
    };
    
    return (
        <input 
            value={localValue}
            onChange={(e) => updateSetting(e.target.value)}
        />
    );
};
```

## Description
- Use React state for immediate UI updates
- Update plugin settings object
- Call plugin.saveSettings() for persistence
- Maintains sync between React and Obsidian