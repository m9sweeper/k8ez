import { createRouter, createWebHistory } from 'vue-router';
import Home from '../components/HomePage.vue';
import HelloWorld from '../components/HelloWorld.vue';

const routes = [
    {
        path: '/',
        name: 'Home',
        component: Home
    },
    {
        path: '/hello',
        name: 'HelloWorld',
        component: HelloWorld
    }
];

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes
});

export default router;