# React Notice Integration

Pattern for using Obsidian's Notice system from React components.

## Pattern
```typescript
const MyComponent: FC<ComponentProps> = ({ app }) => {
    const handleSuccess = () => {
        new Notice("✅ Action completed successfully");
    };
    
    const handleError = (error: Error) => {
        new Notice(`⚠️ Error: ${error.message}`);
    };
    
    const handleAction = async () => {
        try {
            // Perform action
            handleSuccess();
        } catch (error) {
            handleError(error);
        }
    };
    
    return <button onClick={handleAction}>Perform Action</button>;
};
```

## Description
- Import Notice from obsidian package
- Use consistent emoji prefixes for feedback types
- Handle both success and error cases
- Integrate with async operations