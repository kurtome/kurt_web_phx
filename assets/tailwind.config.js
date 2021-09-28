// tailwind.config.js
const { colors } = require('tailwindcss/defaultTheme')

module.exports = {
  theme: {
    fontFamily: {
      'title': ['Lato', 'serif'],
      'ui': ['Lato', 'serif'],
      'body': ['Lato', 'sans-serif'],
      'code': ['Lato', 'sans-serif']
    },
    extend: {
      colors: {
        'body': colors.white,
        'body-contrast': colors.purple['200']
      }
    }
  },
  variants: {
    opacity: ['responsive', 'hover']
  },
  plugins: [],
}
