Vue = require "vue"
VueRouter = require "vue-router"
Vue.use(require('vue-resource'));
Vue.use(VueRouter)

Sandbox = Vue.component('sandbox', require('./app/sandbox'))
# AuditShow = Vue.component('audit-show', require('./app/views/audit_show'))
# AuditIndex = Vue.component('audit-index', require('./app/views/audit_index'))
console.log("test")


App = Vue.extend({})
router = new VueRouter({
  history: true,
  root: "/"
  })
router.map({
  '/': {
    component: Sandbox
  }
})

router.start(App, '#app')
