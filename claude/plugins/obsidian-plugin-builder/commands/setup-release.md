You are helping the user set up GitHub Actions for releasing their Obsidian plugin.

1. Verify prerequisites:
   - Plugin has a git repository
   - GitHub repository is created
   - manifest.json is properly configured
   - package.json version matches manifest.json

2. Create release workflow:
   - Create .github/workflows/release.yml
   - Configure workflow to trigger on version tags
   - Set up Node.js build environment
   - Run build process
   - Create GitHub release with built artifacts

3. Create necessary files:
   - versions.json to track version history
   - version-bump.mjs script to sync versions
   - Update package.json scripts

4. Provide release instructions:
   - How to update version numbers
   - How to create git tags
   - How to push tags to trigger release
   - What files need to be updated

Use this workflow template:
```yaml
name: Release Obsidian plugin

on:
  push:
    tags:
      - "*"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: "18.x"
      - run: npm ci
      - run: npm run build
      - name: Create release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          gh release create "${{ github.ref_name }}" \
            --title "${{ github.ref_name }}" \
            --draft \
            main.js manifest.json styles.css
```

Reference: https://docs.obsidian.md/Plugins/Releasing/Release+your+plugin+with+GitHub+Actions
