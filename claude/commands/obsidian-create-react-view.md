# Create React View

Template for creating a new Obsidian view with React integration.

## Pattern
```typescript
// ViewClass.tsx
export class MyReactView extends ItemView {
    root: Root | null = null;
    
    getViewType() { return "my-react-view"; }
    getDisplayText() { return "My React View"; }
    
    async render() {
        const container = this.containerEl.children[1];
        container.empty();
        this.root = createRoot(container);
        this.root.render(
            <StrictMode>
                <MyReactComponent 
                    app={this.app} 
                    settings={this.settings}
                    view={this} 
                />
            </StrictMode>
        );
    }
    
    async onClose() {
        this.root?.unmount();
    }
}
```

## Description
- Extends ItemView for Obsidian integration
- Uses React 18+ createRoot pattern
- Passes Obsidian context to React components
- Proper cleanup on view close