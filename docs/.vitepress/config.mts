import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Another IPTV Player",
  description: "Free & Open Source",
  base: '/another-iptv-player/',
  themeConfig: {
    logo: '/logo.png',
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Download', link: '/download' },
      { text: 'Support', link: '/information' },
    ],
    sidebar: [
      { text: 'Information', link: '/information' },
      { text: 'FAQ', link: '/faq' },
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/bsogulcan/another-iptv-player' }
    ],
    
  }
})
