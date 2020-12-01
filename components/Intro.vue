<template>
<div class="relative w-full h-full bg-gray-900 flex items-center justify-center">

	<div id="welcome" class="absolute w-auto my-auto select-none font-serif font-semibold text-2xl sm:text-4xl md:text-5xl lg:text-6xl bg-gradient-to-r from-pink-800 via-teal-500 to-indigo-800 bg-clip-text text-transparent flex flex-col items-center justify-center">

		<div id="cool" class="flex items-center justify-center">
			<div id="dance"></div>
			<div class="ml-3">
				<span id="text"></span>
				<span id="cursor" class="text-pink-500">_</span>
			</div>
		</div>

		<div id="explore" class="opacity-0">Explore Three.js</div>

	</div>

	<div class="absolute text-teal-500 flex left-4 top-4">
		<div class="w-12 h-12 text-teal-700 opacity-30 hover:opacity-80 flex items-center justify-center">
			<svg v-if="soundPlaying" @click="musicControl('pause')" class="w-6 h-6 transform scale-200" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" clip-rule="evenodd" d="M2 12C2 6.48 6.48 2 12 2C17.52 2 22 6.48 22 12C22 17.52 17.52 22 12 22C6.48 22 2 17.52 2 12ZM11 16H9V8H11V16ZM12 20C7.59 20 4 16.41 4 12C4 7.59 7.59 4 12 4C16.41 4 20 7.59 20 12C20 16.41 16.41 20 12 20ZM15 16H13V8H15V16Z" fill="currentColor"/>
			</svg>
			<svg v-if="!soundPlaying" @click="musicControl('play')" class="w-6 h-6 transform scale-200" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path fill-rule="evenodd" stroke="none" clip-rule="evenodd" d="M12 2C6.48 2 2 6.48 2 12C2 17.52 6.48 22 12 22C17.52 22 22 17.52 22 12C22 6.48 17.52 2 12 2ZM10 16.5L16 12L10 7.5V16.5ZM4 12C4 16.41 7.59 20 12 20C16.41 20 20 16.41 20 12C20 7.59 16.41 4 12 4C7.59 4 4 7.59 4 12Z" fill="currentColor"/>
			</svg>
		</div>
		
	</div>

	<div id="sceneContainer" class="w-full h-full bg-gray-900"></div>

	<div class="absolute inset-x-0 bottom-0 w-screen h-42 flex justify-evenly items-end">
		<div v-for="index in 64" :key="index" :id="index" class="w-1 md:w-2 lg:w-3 h-0 rounded-t-full bg-gradient-to-t from-pink-600 via-red-600 to-purple-600">

		</div>
	</div>

</div>
</template>

<script>

import * as THREE from 'three';
import {SVGLoader} from '../node_modules/three/examples/jsm/loaders/SVGLoader';
// const OrbitControls = require('three-orbit-controls')(THREE);

import vertex from '@/assets/shaders/vertexParticles.glsl';
import fragment from '@/assets/shaders/fragmentParticles.glsl';


export default {

	data() {

		return {

			sceneContainer: null,
			scene: null,
			renderer: null,
			perspectiveCamera: null,
			cube: null,
			orbitControl: null,

			// clock: new THREE.Clock(),
			gui: null,
			sound: null,
			audioAnalyzer: null,
			soundPlaying: false,
			frequeencyDataLength: 32,

			uniforms: {

				time: { value: 0 },
				expand: { value: 0.0 },
				t: {type: 't', value: null},
				resolution: { value: new THREE.Vector2() },
				mouse: { value: new THREE.Vector2() }

			},

			pictures: [
				'images/purple2.jpg',
				'images/champei2.jpg',
				'images/largerose1.jpg',
				'images/sunhd.jpg',
			],

			pictureIndex: 0,
			sceneTime: 0

		}

	},

	methods: {

		init() {

			this.sceneContainer = document.getElementById('sceneContainer');

			// this.uniforms.resolution.value.x = this.sceneContainer.clientWidth;
			// this.uniforms.resolution.value.y = this.sceneContainer.clientHeight;

			// this.uniforms.t.value = new THREE.TextureLoader().load('images/firststart.jpg');
			this.uniforms.t.value = new THREE.TextureLoader().load(this.pictures[this.pictureIndex]);

			// WebGL Renderer
			{
				this.renderer = new THREE.WebGLRenderer({antialias: true});
				this.renderer.name = "Renderer";
				this.renderer.setClearColor(0x000000);
				this.renderer.setPixelRatio(window.devicePixelRatio);
				this.renderer.setSize(this.sceneContainer.clientWidth, this.sceneContainer.clientHeight);
				
				this.sceneContainer.appendChild(this.renderer.domElement);
			}

			// Scene
			{
				this.scene = new THREE.Scene();
				this.scene.name  = "Scene";
			}
			// Percpective Camera
			{
				let fov = 75;
				let aspect = this.sceneContainer.clientWidth / this.sceneContainer.clientHeight;
				const near = 0.001;
				const far = 5000;
				this.perspectiveCamera = new THREE.PerspectiveCamera(fov, aspect, near, far);
				this.perspectiveCamera.name = "Camera";
				this.perspectiveCamera.position.set(0,0,800);
			}
			// Orbit Control
			// {
			// 	this.orbitControl = new OrbitControls(this.perspectiveCamera, this.renderer.domElement);
			// 	// this.orbitControl.minDistance = 2;
			// 	// this.orbitControl.maxDistance = 400;
			// 	this.orbitControl.update();
			// }
			// Directional Light
			{
				const color = 0xaaaaaa;
				const intensity = 1;
				const light = new THREE.DirectionalLight(color, intensity);
				light.name = "Directional Light";
				light.position.set(5, 15, 5);
				light.lookAt(0,0,0);
				this.scene.add(light);
			}

			// Plane
			{
				// const geometry = new THREE.PlaneBufferGeometry(480*1.5, 820*1.5, 480, 820);
				const geometry = new THREE.PlaneBufferGeometry(1300, 1300, 300, 300);
				const material = new THREE.ShaderMaterial({
					uniforms: this.uniforms,
					fragmentShader: fragment,
					vertexShader: vertex

				})
				// const material = new THREE.MeshPhongMaterial({color: 0xa988ea, emissive: 0xaa66aa});
				// const pMaterial = new THREE.PointsMaterial({color: 0x0089af, size: 0.05});
				let mesh = new THREE.Points(geometry, material);
				// let mesh = new THREE.Mesh(geometry, material);
				this.cube = mesh;
				this.scene.add(mesh);
			}

			// SVG
			// {
			// 	// instantiate a loader
			// 	const loader = new SVGLoader();

			// 	// load a SVG resource
			// 	loader.load(

			// 		// resource URL
			// 		'svg/stack.svg',

			// 		// called when the resource is loaded
			// 		( data ) => {

			// 			const paths = data.paths;
			// 			const group = new THREE.Group();

			// 			for ( let i = 0; i < paths.length; i ++ ) {

			// 				const path = paths[ i ];

			// 				const material = new THREE.MeshBasicMaterial( {
			// 					color: path.color,
			// 					// color: 0xff00ff,
			// 					side: THREE.DoubleSide,
			// 					depthWrite: false
			// 				} );

			// 				const shapes = path.toShapes( true );

			// 				for ( let j = 0; j < shapes.length; j ++ ) {

			// 					const shape = shapes[ j ];
			// 					const geometry = new THREE.ShapeBufferGeometry( shape );
			// 					const mesh = new THREE.Mesh( geometry, material );
			// 					group.add( mesh );

			// 				}

			// 			}

			// 			group.scale.set(5, 5, 5);

			// 			group.position.set(500, 50, 0)

			// 			this.scene.add( group );

			// 		},

			// 		// called when loading is in progresses
			// 		( xhr ) => {

			// 			console.log( ( xhr.loaded / xhr.total * 100 ) + '% loaded' );

			// 		},

			// 		// called when loading has errors
			// 		( error ) => {

			// 			console.log( 'An error happened' );
			// 			console.log( error );

			// 		}
			// 	);
			// }

			//  Audio
			{
				// create an AudioListener and add it to the camera
				const listener = new THREE.AudioListener();
				this.perspectiveCamera.add( listener );

				// create a global audio source
				this.sound = new THREE.Audio( listener );

				// load a sound and set it as the Audio object's buffer
				const audioLoader = new THREE.AudioLoader();
				audioLoader.load( 'sounds/376737_Skullbeatz___Bad_Cat_Maste.mp3', ( buffer ) => {
					this.sound.setBuffer( buffer );
					this.sound.setLoop( true );
					this.sound.setVolume( 0.5 );
					this.sound.play();
					this.soundPlaying = true;
				});

				// create an AudioAnalyser, passing in the sound and desired fftSize
				this.audioAnalyzer = new THREE.AudioAnalyser( this.sound, 128 );

				// get the average frequency of the sound
				// this.soundFrequency = analyser.getAverageFrequency();
				console.log(this.audioAnalyzer.getFrequencyData());
			}

			// Animate
			this.renderer.setAnimationLoop(this.animate);

		},

		animate() {

			this.uniforms.time.value += 0.05;

			this.uniforms.expand.value = this.audioAnalyzer.getFrequencyData()[5] * 0.004;
			this.audioAnalyzer.getFrequencyData().forEach((value, index) => {
				// document.getElementById(index).style.height = value * 0.1;
				// console.log(document.getElementById(index))
				document.getElementById(index+1).style.height = `${value * 0.6}px`;
			});

			this.sceneTime += 1;
			this.sceneTime %= 2000;

			// this.uniforms.expand.value += 0.03
			if(this.sceneTime % 500 == 0 ){
				this.pictureIndex += 1;
				this.pictureIndex %= 3;
				// this.uniforms.t.value = new THREE.TextureLoader().load(this.pictures[this.pictureIndex]);
			}else if(this.sceneTime % 500 == 250 ){
				this.uniforms.t.value = new THREE.TextureLoader().load(this.pictures[this.pictureIndex]);
				// this.uniforms.expand.value *= 0.99
			}
            
			this.renderer.render(this.scene, this.perspectiveCamera);
		},

		musicControl(action){
			// this.sound.pause();
			switch(action) {
				case 'play':
					this.sound.play();
					this.soundPlaying = true;
					break;
				case 'pause':
					this.sound.pause();
					this.soundPlaying = false;
					break;
				default:
					// code block
			}
		},

		onWindowResize() {

			this.renderer.setSize(this.sceneContainer.clientWidth, this.sceneContainer.clientHeight)

			this.perspectiveCamera.aspect = this.sceneContainer.clientWidth / this.sceneContainer.clientHeight;
			this.perspectiveCamera.updateProjectionMatrix();

		}

	},

	mounted() {
		
		this.init();

		// this.uniforms.expand.value = this.soundFrequency;

		// if (typeof window !== 'undefined') {
		// 	const gui = require('three/examples/jsm/libs/dat.gui.module');

		// 	// Do stuff with gui
		// 	this.gui = new gui.GUI();
		// 	this.gui.add(this.uniforms.expand, 'value', -3.0, 3.0, 0.01);
		// }

		// import dat from 'three/examples/jsm/libs/dat.gui.module';


		const gsap = this.$gsap;

		const TextPlugin = this.$TextPlugin;
		gsap.registerPlugin(TextPlugin);

		gsap.to('#cursor', {
			opacity: 0,
			duration: 0.5,
			ease: "power2",
			repeat: -1
		});

		gsap.to('#dance', {
			duration: 1,
			text: 'Dance with',
			ease: "power2",
			delay: 0.3
		});

		// const tl = gsap.timeline();

		let mainTimeline = gsap.timeline({
			repeat: 0,
			delay: 1.5,
			onComplete: () =>{
				gsap.to('#text', {duration: 1, text: '💕'});

				let tl = gsap.timeline({delay: 4})
				tl.fromTo('#welcome',
					{duration: 1, y: 'vh', ease: 'power2'},
					{duration: 1, y: '-7vw', ease: 'power2'},
					0
				)
				tl.to('#cool', {duration: 1, opacity: 0, ease: 'power2'}, '-=0')
				tl.to('#explore', {duration: 2, opacity: 1, ease: 'power2'}, '-=3.5')
			}
		});

		const words = ['the flowers', 'me'];

		words.forEach( (word) => {
			let tl = gsap.timeline({repeat: 1,yoyo: true});
			tl.to('#text', {duration: 1, text: word});
			mainTimeline.add(tl);
		});		



		window.addEventListener('resize', this.onWindowResize, false);

	},

}
</script>
