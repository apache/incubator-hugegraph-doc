/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const projectName = "HugeGraph";
const mainRepoName = "incubator-hugegraph";
const siteRepoName = "incubator-hugegraph-doc";

const config: Config = {
  title: `Apache ${projectName}`,
  tagline: `A convenient, efficient, and adaptable graph database compatible with the Apache TinkerPop3 framework and the Gremlin query language.`,
  favicon: 'img/favicon.ico',

  url: `https://${projectName.toLowerCase()}.apache.org/`,
  baseUrl: '/',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'throw',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en','zh'],
    localeConfigs: {
      en: {
        htmlLang: 'en-US',
        label: 'English',
        direction: 'ltr',
        calendar: 'gregory',
        path: 'en',
      },
      // You can omit a locale (e.g. fr) if you don't need to override the defaults
      zh: {
        direction: 'ltr',
        path: 'zh',
        htmlLang: 'zh-CN',
      },
    },
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './docs/sidebars.ts',
          editUrl: `https://github.com/apache/${siteRepoName}/tree/main/`,
        },
        blog: {
          blogSidebarCount: 'ALL',
          blogSidebarTitle: 'All our posts',
          showReadingTime: true,
          editUrl: `https://github.com/apache/${siteRepoName}/tree/main/`,
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  // search plugin: https://github.com/praveenn77/docusaurus-lunr-search
  plugins: [[ require.resolve('docusaurus-lunr-search'), {
    languages: ['en'],
    highlightResult: true,
  }]],

  themeConfig: {
    // TODO: Replace with your project's social card
    image: 'img/social-card.png',
    navbar: {
      logo: {
        alt: 'Logo',
        src: 'img/logo.svg',
      },
      items: [
        {type: 'docSidebar', sidebarId: 'docs', position: 'right', label: 'Docs'},
        {to: '/blog', label: 'Blog', position: 'right'},
        {
          type: 'dropdown',
          label: 'ASF',
          position: 'right',
          items: [
            {
              label: 'Foundation',
              to: 'https://www.apache.org/'
            },
            {
              label: 'License',
              to: 'https://www.apache.org/licenses/'
            },
            {
              label: 'Events',
              to: 'https://www.apache.org/events/current-event.html'
            },
            {
              label: 'Privacy',
              to: 'https://privacy.apache.org/policies/privacy-policy-public.html'
            },
            {
              label: 'Security',
              to: 'https://www.apache.org/security/'
            },
            {
              label: 'Sponsorship',
              to: 'https://www.apache.org/foundation/sponsorship.html'
            },
            {
              label: 'Thanks',
              to: 'https://www.apache.org/foundation/thanks.html'
            },
            {
              label: 'Code of Conduct',
              to: 'https://www.apache.org/foundation/policies/conduct.html'
            }
          ]
        },
        {
          href: `https://github.com/apache/${mainRepoName}`,
          position: 'right',
          className: 'header-github-link',
          'aria-label': 'GitHub repository',
        },
        {
          type:'localeDropdown',
          position:'right'
        }
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Community',
          items: [
            {
              label: 'Mailing list',
              href: 'https://lists.apache.org/list.html?dev@hugegraph.apache.org'
            },
            {
              label: 'WeChat',
              href: 'https://github.com/apache/incubator-hugegraph-doc/blob/master/assets/images/wechat.png?raw=true'
            }
          ]
        },
        {
          title: 'Documentation',
          items: [
            {
              label: 'Introduction',
              to: '/docs/intro'
            },
            {
              label: 'Guide',
              to: '/docs/guide/architecture-overview'
            }
          ]
        },
        {
          title: 'Repositories',
          items: [
            {
              label: 'HugeGraph Server',
              href: 'https://github.com/apache/hugegraph'
            },
            {
              label: 'HugeGraph ToolChain',
              href: 'https://github.com/apache/hugegraph-toolchain'
            },
            {
              label: 'HugeGraph Computer',
              href: 'https://github.com/apache/hugegraph-computer'
            },
            {
              label: 'HugeGraph AI',
              href: 'https://github.com/apache/incubator-hugegraph-ai'
            }
          ]
        }
      ],
      logo: {
        width: 200,
        src: "/img/apache-incubator.svg",
        href: "https://incubator.apache.org/",
        alt: "Apache Incubator logo"
      },
      copyright: `<div>
      <p>
        Apache ${projectName} is an effort undergoing incubation at The Apache Software Foundation (ASF), sponsored by the Apache Incubator. Incubation is required of all newly accepted projects until a further review indicates that the infrastructure, communications, and decision making process have stabilized in a manner consistent with other successful ASF projects. While incubation status is not necessarily a reflection of the completeness or stability of the code, it does indicate that the project has yet to be fully endorsed by the ASF.
      </p>
      <p>
        Copyright © ${new Date().getFullYear()} The Apache Software Foundation, Licensed under the Apache License, Version 2.0. <br/>
        Apache, the names of Apache projects, and the feather logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries.
      </p>
      </div>`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
