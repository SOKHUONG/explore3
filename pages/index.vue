<template>
<div class="w-screen bg-gray-900 flex relative">

    <nav v-if="showNav" class="z-50 fixed">
        <Nav @externalClick="showNav = $event"/>
    </nav>

    <main class="w-full bg-gray-900 flex flex-col">

        <div class="w-screen h-screen bg-gray-800">
            <Intro/>
        </div>

    </main>

</div>
</template>

<script>

import makeAScene from '@/assets/code/make-a-scene.txt';
import globalAudio from '@/assets/code/global-audio.txt';

export default {

    data() {
        
        return {
            showNav: false,
            code: makeAScene,
            globalAudio: globalAudio
        }
    },

    methods: {
        // scroll(){
        //     this.$gsap.to(window, {
        //         duration: 2,
        //         scrollTo: {
        //             y: '#globalaudio'
        //         }
        //     })
        // },

        // scrollCode() {
        //     this.$gsap.to('#globalaudio', {
        //         duration: 1,
        //         scrollTo: {
        //             y: 100
        //         }
        //     })
        // }
    },

    mounted() {


        // const gsap = this.$gsap
        // // const ExpoScaleEase = this.$ExpoScaleEase
        // // const ScrollToPlugin = this.$ScrollToPlugin
        // const ScrollTrigger = this.$ScrollTrigger;
        // const ScrollToPlugin = this.$ScrollToPlugin;

        // gsap.registerPlugin(ScrollTrigger, ScrollToPlugin)

        // gsap.from('#code', {
        //     duration: 2,
        //     ease: 'power2.out',
        //     x: '-50vw',
        //     // rotation: '45deg',
        //     opacity: 0,
        //     scrollTrigger: {
        //         trigger: '#code',
        //         markers: true,
        //         start: 'top 75%',
        //         end: 'bottom 25%',

        //         // events: 'onEnter onLeave onEnterBack onLeaveBack'
        //         toggleActions: 'restart complete reverse reset'
        //         // options: play pause resume reset restart cocmplete reverse none
        //     }

        // })

    }

}
</script>
