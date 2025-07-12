import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "Another IPTV Player",
  description: "Free & Open Source",
  sitemap: {
    hostname: 'https://another-iptv-player.com'
  },
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
