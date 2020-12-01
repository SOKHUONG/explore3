<template>
<div class="w-screen bg-gray-500 flex relative">

    <button @click="showNav = !showNav" class="w-16 text-gray-200 fixed">

        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8h16M4 16h16"/>
        </svg>

        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path 
                stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z">
            </path>
        </svg>
    </button>

    <nav v-if="showNav" class="z-50 fixed">
        <Nav @externalClick="showNav = $event"/>
    </nav>

    <main class="w-full bg-gradient-to-br from-teal-800 to-indigo-800 flex flex-col">

        <button @click="scroll" class="absolute top-0 right-0 text-gray-200">scroll</button>

        <div class="w-screen h-screen bg-gray-800">
            <Intro/>
        </div>

        <div class="custom-scrollbar w-full h-96 rounded-lg overflow-hidden bg-green-800 flex justify-center items-center">
            <Prism id="code" language="js" class="hide-scrollbar rounded-lg line-numbers w-100 max-w-3/4 transform skew-y-3 skew-x-12">{{code}}</Prism>
        </div>

        <div class="relative custom-scrollbar w-full h-96 rounded-lg overflow-hidden bg-green-800 flex justify-center items-center">
            <button @click="scrollCode" class="absolute top-0 right-0">C</button>
            <Prism id="globalaudio" language="js" class="hide-scrollbar rounded-lg line-numbers w-100 max-w-3/4 max-h-3/4 transform skew-y-3 skew-x-12">{{globalAudio}}</Prism>
        </div>

        <div class="w-full h-108"></div>
        <div class="w-full h-108"></div>

    </main>

</div>
</template>

<script>

import Prism from '@/plugins/prism';
import prism from 'prismjs';
import makeAScene from '@/assets/code/make-a-scene.txt';
import globalAudio from '@/assets/code/global-audio.txt';

export default {

    components: {
        Prism
    },

    data() {
        
        return {
            showNav: false,
            code: makeAScene,
            globalAudio: globalAudio
        }
    },

    methods: {
        scroll(){
            this.$gsap.to(window, {
                duration: 2,
                scrollTo: {
                    y: '#globalaudio'
                }
            })
        },

        scrollCode() {
            this.$gsap.to('#globalaudio', {
                duration: 1,
                scrollTo: {
                    y: 100
                }
            })
        }
    },

    mounted() {

        prism.highlightAll()

       const gsap = this.$gsap
        // const ExpoScaleEase = this.$ExpoScaleEase
        // const ScrollToPlugin = this.$ScrollToPlugin
        const ScrollTrigger = this.$ScrollTrigger;
        const ScrollToPlugin = this.$ScrollToPlugin;

        gsap.registerPlugin(ScrollTrigger, ScrollToPlugin)

        gsap.from('#code', {
            duration: 2,
            ease: 'power2.out',
            x: '-50vw',
            // rotation: '45deg',
            opacity: 0,
            scrollTrigger: {
                trigger: '#code',
                markers: true,
                start: 'top 75%',
                end: 'bottom 25%',

                // events: 'onEnter onLeave onEnterBack onLeaveBack'
                toggleActions: 'restart complete reverse reset'
                // options: play pause resume reset restart cocmplete reverse none
            }

        })

    }

}
</script>
