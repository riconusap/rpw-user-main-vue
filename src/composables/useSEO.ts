// SEO Composable for managing meta tags across pages
import { useHead } from '@unhead/vue';

export interface SEOOptions {
  title: string;
  description: string;
  keywords?: string;
  image?: string;
  url?: string;
  type?: string;
  author?: string;
  publishedTime?: string;
  modifiedTime?: string;
}

export function useSEO(options: SEOOptions) {
  const baseUrl = import.meta.env.VITE_BASE_URL || 'https://rpwadvocates.com';
  const siteName = 'R. Prama Wijaya & Partners Law Firm';
  const defaultImage = `${baseUrl}/img/logo.png`;

  useHead({
    // Title
    title: options.title,
    titleTemplate: (title) => title ? `${title} | ${siteName}` : siteName,

    // Meta Tags
    meta: [
      // Basic Meta
      { name: 'description', content: options.description },
      { name: 'keywords', content: options.keywords || 'law firm, legal services, attorney, Indonesia, Jakarta' },
      { name: 'author', content: options.author || 'R. Prama Wijaya & Partners' },

      // Open Graph / Facebook
      { property: 'og:type', content: options.type || 'website' },
      { property: 'og:site_name', content: siteName },
      { property: 'og:title', content: options.title },
      { property: 'og:description', content: options.description },
      { property: 'og:image', content: options.image || defaultImage },
      { property: 'og:url', content: options.url || baseUrl },
      { property: 'og:locale', content: 'id_ID' },

      // Twitter Card
      { name: 'twitter:card', content: 'summary_large_image' },
      { name: 'twitter:site', content: '@rpwadvocates' },
      { name: 'twitter:title', content: options.title },
      { name: 'twitter:description', content: options.description },
      { name: 'twitter:image', content: options.image || defaultImage },

      // Additional Meta
      { name: 'robots', content: 'index, follow' },
      { name: 'googlebot', content: 'index, follow' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1.0' },
      { 'http-equiv': 'Content-Type', content: 'text/html; charset=utf-8' },

      // Article specific (if applicable)
      ...(options.publishedTime ? [{ property: 'article:published_time', content: options.publishedTime }] : []),
      ...(options.modifiedTime ? [{ property: 'article:modified_time', content: options.modifiedTime }] : []),
    ],

    // Link Tags
    link: [
      { rel: 'canonical', href: options.url || baseUrl },
      { rel: 'icon', type: 'image/png', href: '/img/logo.png' },
    ],

    // Structured Data (JSON-LD)
    script: [
      {
        type: 'application/ld+json',
        innerHTML: JSON.stringify({
          '@context': 'https://schema.org',
          '@type': 'LegalService',
          name: siteName,
          description: options.description,
          url: baseUrl,
          logo: defaultImage,
          image: options.image || defaultImage,
          address: {
            '@type': 'PostalAddress',
            addressLocality: 'Jakarta',
            addressCountry: 'ID',
          },
          contactPoint: {
            '@type': 'ContactPoint',
            telephone: '+62-21-29557422',
            contactType: 'customer service',
            email: 'proxy@rpwadvocates.com',
          },
          sameAs: [
            'https://twitter.com/rpwadvocates',
            'https://facebook.com/rpwadvocates',
            'https://linkedin.com/company/rpwadvocates',
            'https://instagram.com/rpwadvocates',
          ],
        }),
      },
    ],
  });
}

// Predefined SEO configurations for each page
export const seoConfigs = {
  home: {
    title: 'Home',
    description: 'R. Prama Wijaya & Partners is a leading law firm in Jakarta, Indonesia, providing comprehensive legal services including corporate law, civil law, criminal law, and more.',
    keywords: 'law firm Jakarta, Indonesian attorney, legal services Indonesia, corporate law, civil law, Ramon Prama Wijaya',
  },
  teams: {
    title: 'Our Attorney Team',
    description: 'Meet our experienced legal team led by Ramon Prama Wijaya, S.H., M.H. Our attorneys specialize in various areas of Indonesian law.',
    keywords: 'attorneys Indonesia, legal team, Ramon Prama Wijaya, law professionals Jakarta',
  },
  articles: {
    title: 'Legal Articles & News',
    description: 'Stay updated with the latest legal news, articles, and insights on Indonesian law, regulations, and legal developments.',
    keywords: 'legal articles, Indonesian law news, legal insights, law blog, legal updates',
  },
  contact: {
    title: 'Contact Us',
    description: 'Contact R. Prama Wijaya & Partners for professional legal consultation and services. We are located in Jakarta, Indonesia.',
    keywords: 'contact lawyer, legal consultation Jakarta, law firm contact, attorney consultation',
  },
  about: {
    title: 'About Our Firm',
    description: 'Learn about R. Prama Wijaya & Partners, our history, mission, and commitment to providing excellent legal services in Indonesia.',
    keywords: 'about law firm, legal services Jakarta, law firm Indonesia, professional attorneys',
  },
};
