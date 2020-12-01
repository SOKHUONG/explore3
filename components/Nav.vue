<template>
<div v-click-outside="externalClick" class="w-64 h-screen absolute bg-teal-800 flex flex-col">
    <section class="w-full bg-indigo-700">logo</section>
    <section class="w-full bg-green-700 mt-auto">
        <div class="w-full h-8">
            <nuxt-link to="/post-processing">post processing</nuxt-link>
        </div>
    </section>
</div>
</template>

<script>

import vClickOutside from 'v-click-outside';

export default {

    directives: {
		clickOutside: vClickOutside.directive,
    },
    
    methods: {
        externalClick() {
            this.$emit('externalClick', false)
        }
    }

}
</script>

<style>

</style>