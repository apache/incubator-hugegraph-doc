#! /bin/bash

#
# Modified By 黄伟枞<weicong@cuav.net>
# Modify:
# 1. 增加 nav.js 的编译
# 2. 修改 gitbook ico 图标
# 3. 增加 cuav ico，cuav logo图标
# 

# Cleanup folder
rm -rf _assets

# Recreate folder
mkdir -p _assets/website/
mkdir -p _assets/ebook/

# Compile JS
browserify src/js/core/index.js | uglifyjs -mc > _assets/website/gitbook.js
browserify src/js/theme/index.js | uglifyjs -mc > _assets/website/theme.js

uglifyjs src/js/cuav/cuav-nav.js -o _assets/website/cuav-nav.js -mc

# Compile Website CSS
lessc -clean-css src/less/website.less _assets/website/style.css
node-sass --output-style compressed src/scss/cuav-style.scss > _assets/website/cuav-style.css

# Compile eBook CSS
lessc -clean-css src/less/ebook.less _assets/ebook/ebook.css
lessc -clean-css src/less/pdf.less _assets/ebook/pdf.css
lessc -clean-css src/less/mobi.less _assets/ebook/mobi.css
lessc -clean-css src/less/epub.less _assets/ebook/epub.css

# Copy fonts
mkdir -p _assets/website/fonts
cp -R node_modules/font-awesome/fonts/ _assets/website/fonts/fontawesome/

# Copy icons
mkdir -p _assets/website/images
cp node_modules/gitbook-logos/output/favicon.ico _assets/website/images/gitbook.ico
cp node_modules/gitbook-logos/output/apple-touch-icon-152.png _assets/website/images/apple-touch-icon-precomposed-152.png
cp images/cuav.ico _assets/website/images/
cp images/logo.png _assets/website/images/
