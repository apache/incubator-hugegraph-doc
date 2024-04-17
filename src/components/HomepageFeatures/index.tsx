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

import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Convenient',
    Svg: require('@site/static/img/banner/convenient.svg').default,
    description: (
      <>
        Not only supports Gremlin graph query language and RESTful
        API but also provides commonly used graph algorithm APIs. To
        help users easily implement various queries and analyses,
        HugeGraph has a full range of accessory tools, such as
        supporting distributed storage, data replication, scaling
        horizontally, and supports many built-in backends of storage
        engines.
      </>
    ),
  },
  {
    title: 'Efficient',
    Svg: require('@site/static/img/banner/efficient.svg').default,
    description: (
      <>
        Has been deeply optimized in graph storage and graph
        computation. It provides multiple batch import tools that can
        easily complete the fast-import of tens of billions of data,
        achieves millisecond-level response for graph retrieval through
        ameliorated queries, and supports concurrent online and real-
        time operations for thousands of users.
      </>
    ),
  },
  {
    title: 'Adaptable',
    Svg: require('@site/static/img/banner/adaptable.svg').default,
    description: (
      <>
        Adapts to the Apache Gremlin standard graph query language
        and the Property Graph standard modeling method, and both
        support graph-based OLTP and OLAP schemes. Furthermore,
        HugeGraph can be integrated with Hadoop and Spark’s big data
        platforms, and easily extend the back-end storage engine
        through plug-ins.
      </>
    ),
  },
];

function Feature({ title, description, Svg }: FeatureItem) {
  console.log('icon', Svg);
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center padding-horiz--md">
        <div> {<Svg role="img" className={styles.featureSvg} />} </div>
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
