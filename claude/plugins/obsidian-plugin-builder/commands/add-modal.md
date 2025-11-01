You are helping the user create a modal for their Obsidian plugin.

1. Ask the user what type of modal they need:
   - Simple Modal: Display information
   - Input Modal: Collect user input
   - SuggestModal: Searchable dropdown/autocomplete
   - Custom Modal: Complex UI with forms/buttons

2. Create the modal class:
   - Extend Modal or SuggestModal from 'obsidian'
   - Implement constructor with App and any needed params
   - Implement onOpen() for rendering UI
   - Implement onClose() for cleanup
   - For SuggestModal: implement getSuggestions(), renderSuggestion(), onChooseSuggestion()

3. Add UI components in onOpen():
   - Use contentEl.createEl() for elements
   - Use TextAreaComponent, ButtonComponent, etc. for controls
   - Style with CSS classes or inline styles
   - Add event handlers for interactions

4. Integrate with the plugin:
   - Trigger modal with new YourModal(this.app).open()
   - Pass data to modal via constructor
   - Handle modal results via callbacks or promises

Reference instruct plugin for InstructionModal and FindInstructionModal examples.
