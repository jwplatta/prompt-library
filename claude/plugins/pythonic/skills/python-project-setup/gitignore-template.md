# Python .gitignore Template

```gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
.python-version

# pipenv
Pipfile.lock

# poetry
poetry.lock

# pdm
.pdm.toml

# PEP 582
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/

# Ruff
.ruff_cache/

# uv
uv.lock

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Project specific
*.db
*.sqlite
*.sqlite3
data/
logs/
tmp/
temp/
```

## Explanation of Key Patterns

### Python Runtime Files
- `__pycache__/` - Compiled bytecode cache
- `*.pyc`, `*.pyo`, `*.pyd` - Compiled Python files
- `*.so` - Compiled C extensions

### Package/Build Artifacts
- `dist/`, `build/` - Build output directories
- `*.egg-info/` - Package metadata
- `.eggs/` - Installed packages directory

### Virtual Environments
- `.venv/`, `venv/`, `env/` - Virtual environment directories
- Always create virtual environments, never commit them

### Testing & Coverage
- `.pytest_cache/` - Pytest cache
- `.coverage` - Coverage data files
- `htmlcov/` - HTML coverage reports

### Type Checking & Linting
- `.mypy_cache/` - Mypy cache
- `.ruff_cache/` - Ruff cache
- `.pytype/` - Pytype cache

### Documentation
- `docs/_build/` - Sphinx build output
- `/site` - MkDocs build output

### Environment Variables
- `.env` - Environment variable files (NEVER commit these)
- Should contain secrets, API keys, database URLs

### IDE Files
- `.vscode/` - VSCode settings (some teams commit this)
- `.idea/` - PyCharm settings
- `.DS_Store` - macOS file system metadata

## Customization Tips

1. **Commit `.vscode/` if desired**: Remove from .gitignore to share editor settings
2. **Project-specific data**: Add custom directories for data files, logs, etc.
3. **Lock files**: Consider keeping `uv.lock` for reproducible builds
4. **Documentation**: Remove `docs/_build/` if you want to commit built docs
