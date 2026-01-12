/* eslint-disable */
declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

declare module 'jquery' {
  const $: any;
  export default $;
}

declare module 'owl.carousel' {
  const owlCarousel: any;
  export default owlCarousel;
}

declare module 'waypoints/lib/jquery.waypoints.min.js' {
  const waypoints: any;
  export default waypoints;
}

declare module 'counterup/jquery.counterup.min.js' {
  const counterup: any;
  export default counterup;
}

declare module 'jquery.easing' {
  const easing: any;
  export default easing;
}

declare module 'aos' {
  interface AosOptions {
    duration?: number;
    delay?: number;
    once?: boolean;
    mirror?: boolean;
    anchorPlacement?: string;
  }

  const AOS: {
    init: (options?: AosOptions) => void;
    refresh: () => void;
    refreshHard: () => void;
  };

  export default AOS;
}
