# 🚀 Installation Instructions

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js**: Version 18.0.0 or higher
- **npm**: Version 9.0.0 or higher (comes with Node.js)
- **Git**: For version control (optional but recommended)
- **Code Editor**: VS Code recommended

### Check Your Versions

```bash
node --version   # Should be v18.0.0 or higher
npm --version    # Should be 9.0.0 or higher
```

### Install Node.js (if needed)

**macOS:**
```bash
# Using Homebrew
brew install node
```

**Windows:**
Download from [nodejs.org](https://nodejs.org)

**Linux:**
```bash
# Using nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

---

## 📦 Installation Steps

### Step 1: Navigate to Project Directory

```bash
cd /Users/laptop/Downloads/ABDM/Compressed/rpw-user-main
```

### Step 2: Install Dependencies

This will install all required npm packages from `package.json`.

```bash
npm install
```

**Expected output:**
```
added 423 packages, and audited 424 packages in 45s

120 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

**Note:** Installation may take 1-3 minutes depending on your internet speed.

### Step 3: Verify Installation

Check that `node_modules` directory was created:

```bash
ls -la | grep node_modules
```

You should see:
```
drwxr-xr-x  423 user  staff  13536 Jan 12 10:00 node_modules
```

---

## ⚙️ Configuration (Optional)

### Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env
```

Edit `.env` with your settings:

```env
VITE_APP_TITLE=R. Prama Wijaya Law Firm
VITE_APP_DESCRIPTION=Committed to Excellence
# Add other environment variables as needed
```

---

## 🏃‍♂️ Running the Application

### Development Mode

Start the development server with hot module replacement:

```bash
npm run dev
```

**Expected output:**
```
VITE v5.0.0  ready in 423 ms

➜  Local:   http://localhost:3000/
➜  Network: use --host to expose
➜  press h + enter to show help
```

The application will automatically open in your default browser at `http://localhost:3000`

### Preview Production Build

Build and preview the production version:

```bash
npm run build
npm run preview
```

---

## 🔧 Available Scripts

### `npm run dev`
Starts the development server with hot module replacement.
- **Port:** 3000
- **Auto-open:** Yes
- **HMR:** Enabled

### `npm run build`
Creates an optimized production build.
- **Output:** `dist/` directory
- **Minified:** Yes
- **Source maps:** Included

### `npm run preview`
Preview the production build locally.
- **Port:** 4173
- **Requires:** Must run `npm run build` first

---

## 📂 Project Structure After Installation

```
rpw-user-main/
├── node_modules/              # Installed dependencies (423 packages)
├── src/                       # Source code
├── public/                    # Static assets
├── dist/                      # Build output (after npm run build)
├── package.json               # Dependencies list
├── package-lock.json          # Locked versions
├── vite.config.ts             # Vite configuration
├── tsconfig.json              # TypeScript configuration
└── [documentation files]      # README, guides, etc.
```

---

## 🐛 Troubleshooting

### Issue: `npm install` fails

**Solution 1: Clear npm cache**
```bash
npm cache clean --force
npm install
```

**Solution 2: Delete node_modules and reinstall**
```bash
rm -rf node_modules package-lock.json
npm install
```

**Solution 3: Use different registry (if slow/blocked)**
```bash
npm config set registry https://registry.npmmirror.com
npm install
```

---

### Issue: Port 3000 already in use

**Solution 1: Kill the process**
```bash
# macOS/Linux
lsof -ti:3000 | xargs kill -9

# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

**Solution 2: Change port in vite.config.ts**
```typescript
server: {
  port: 3001, // Use different port
  open: true,
}
```

---

### Issue: TypeScript errors

**Solution: Run type check**
```bash
npm run build
```

This will show all TypeScript errors. Fix them in the source code.

---

### Issue: Module not found errors

**Solution 1: Reinstall dependencies**
```bash
rm -rf node_modules package-lock.json
npm install
```

**Solution 2: Check import paths**
Make sure you're using `@/` for absolute imports:
```typescript
// Correct
import MyComponent from '@/components/MyComponent.vue';

// Wrong
import MyComponent from '../components/MyComponent.vue';
```

---

### Issue: Build fails

**Check for:**
1. TypeScript errors: `npm run build`
2. Missing dependencies: `npm install`
3. Syntax errors: Check console output
4. Disk space: Ensure you have at least 500MB free

---

### Issue: jQuery not defined

**This is already fixed in the project**, but if you encounter it:

Make sure jQuery is imported BEFORE Bootstrap in `main.ts`:
```typescript
import 'jquery';                              // First
import 'bootstrap/dist/js/bootstrap.bundle';  // Second
```

---

### Issue: AOS animations not working

**Verify:**
1. AOS CSS is imported in `main.ts`
2. `AOS.init()` is called in `App.vue`'s `onMounted()`
3. `data-aos` attributes exist on elements

---

## ✅ Verification Checklist

After installation, verify everything works:

- [ ] `npm install` completed without errors
- [ ] `node_modules` directory exists
- [ ] `npm run dev` starts server successfully
- [ ] Browser opens automatically at http://localhost:3000
- [ ] No console errors in browser
- [ ] Page loads and displays correctly
- [ ] Navigation works (click on menu items)
- [ ] Images load correctly
- [ ] Animations work (scroll down the page)
- [ ] Carousel auto-plays on homepage
- [ ] Back to top button appears when scrolling

---

## 📊 Expected File Sizes

After installation:

```
node_modules/     ~200 MB
src/              ~50 KB
dist/ (built)     ~2 MB
Total:            ~202 MB
```

After production build:

```
dist/
├── index.html                ~2 KB
├── assets/
│   ├── index-[hash].js       ~500 KB (includes all code)
│   ├── index-[hash].css      ~300 KB (includes Bootstrap, custom CSS)
│   └── vendor-[hash].js      ~200 KB (Vue, Router, Pinia)
└── img/ (copied from root)   ~varies
```

---

## 🎯 Next Steps

After successful installation:

1. **Read the documentation:**
   - [QUICK-START.md](./QUICK-START.md) - For immediate usage
   - [README-VUE.md](./README-VUE.md) - For project overview
   - [MIGRATION-GUIDE.md](./MIGRATION-GUIDE.md) - For technical details

2. **Start development:**
   - Review [CHECKLIST.md](./CHECKLIST.md) for tasks
   - Use [COMPONENT-TEMPLATE.vue](./COMPONENT-TEMPLATE.vue) for new components
   - Follow [ARCHITECTURE.md](./ARCHITECTURE.md) for understanding structure

3. **Test the application:**
   - Navigate through all pages
   - Test responsive design (resize browser)
   - Check console for errors
   - Verify all links work

---

## 🆘 Getting Help

If you encounter issues not covered here:

1. **Check documentation files:**
   - README-VUE.md
   - MIGRATION-GUIDE.md
   - TROUBLESHOOTING section in this file

2. **Check logs:**
   - Terminal output during `npm install`
   - Browser console (F12) for runtime errors
   - Vite dev server output

3. **Common resources:**
   - [Vue 3 Documentation](https://vuejs.org)
   - [Vite Documentation](https://vitejs.dev)
   - [TypeScript Handbook](https://www.typescriptlang.org/docs/)

---

## 🔒 Security Note

Before deploying to production:

1. **Review dependencies** for vulnerabilities:
   ```bash
   npm audit
   npm audit fix  # If issues found
   ```

2. **Update outdated packages:**
   ```bash
   npm outdated
   npm update
   ```

3. **Set environment variables** properly:
   - Don't commit `.env` to version control
   - Use `.env.example` as template
   - Set production values on hosting platform

---

## 💡 Pro Tips

### Faster Installation

Use `pnpm` instead of `npm` for faster installs:
```bash
npm install -g pnpm
pnpm install
```

### VS Code Extensions

Recommended extensions for development:
- **Volar** - Vue 3 language support
- **TypeScript Vue Plugin (Volar)** - TS support for Vue
- **ESLint** - Code linting
- **Prettier** - Code formatting

Install them:
```
1. Open VS Code
2. Go to Extensions (Cmd/Ctrl + Shift + X)
3. Search for each extension
4. Click Install
```

### Auto Format on Save

Add to VS Code settings (`.vscode/settings.json`):
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

---

## 📞 Support

**Project Maintainer:** Development Team
**Created By:** GitHub Copilot
**Date:** January 12, 2026

For project-specific questions, refer to the documentation files in this repository.

---

**Installation Status:** ✅ Complete this guide and you're ready to develop!
