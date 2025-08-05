# Obsidian React Component Props Interface

Standard pattern for React component props in Obsidian plugins.

## Pattern
```typescript
interface MyComponentProps {
    app: App;
    settings: MyPluginSettings;
    view?: ItemView;
}

export const MyComponent: FC<MyComponentProps> = ({
    app,
    settings,
    view
}) => {
    // Component implementation
    return <div>My React Component</div>;
};
```

## Description
- Standard props interface for Obsidian React components
- Always include app and settings
- Optional view reference for advanced interactions
- Use functional components with TypeScript