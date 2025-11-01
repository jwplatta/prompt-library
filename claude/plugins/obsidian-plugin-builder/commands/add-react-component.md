You are helping the user add a React component to their Obsidian plugin.

1. Verify React is set up:
   - Check package.json for react and react-dom dependencies
   - Check for @types/react in devDependencies
   - Verify esbuild config handles JSX

2. Ask the user about the component:
   - Component purpose and UI
   - Where it will be rendered (modal, view, sidebar, etc.)
   - Props and state needed
   - Any Obsidian API integration

3. Create the React component:
   - Create .tsx file in appropriate directory
   - Use functional components with hooks
   - Import necessary Obsidian types
   - Implement component logic

4. Integrate with Obsidian:
   - Use ReactDOM.render() to mount component
   - Create ItemView extension if it's a custom view
   - Properly unmount component in cleanup
   - Use Obsidian's styling system for consistency

Example pattern:
```typescript
import { ItemView } from 'obsidian';
import * as React from 'react';
import { createRoot, Root } from 'react-dom/client';

export class MyReactView extends ItemView {
  root: Root | null = null;

  onOpen() {
    const container = this.containerEl.children[1];
    container.empty();
    this.root = createRoot(container);
    this.root.render(<MyComponent />);
  }

  onClose() {
    this.root?.unmount();
  }
}
```

Reference example plugins for React integration patterns.
