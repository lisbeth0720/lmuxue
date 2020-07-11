

主要分为两类：

　　1.父子组件间的传值

　　2.非父子组件间的传值

1.父子组件间传值

　　父组件向子组件传值

　　第一种方式:

　　　　　　props　　　

　　　　　　父组件嵌套的子组件中，使用v-bind:msg=‘xxxx’进行对象的绑定，子组件中通过定义props接收对应的msg对象如图

　　　　　　父组件代码

复制代码
<template>
  <div>
    <!-- 注意  :msg 后面是一个对象，值是字符串时,需要写冒号，如果省略：就是一个字符串 -->
    <!-- <m-child msg="from Parent msg" ></m-child> -->
    <m-child v-bind:msg="'from Parent msg'" ></m-child>
  </div>
</template>

<script>
// 引入子组件
import MChild from './Child'
export default {
  data () {
    return {
      msg: ''
    }
  },
  components: {
    MChild,
  },
复制代码
　　　　　子组件代码

复制代码
<template>
  <div>
    <h5>{{msg}}</h5>
  </div>
</template>

<script>
export default {
  // 要接受父组件传递的参数
  props: {
    msg: {
      type: String,
      default: ''
    },
  },
复制代码
　　第二种方式：

　　　　　使用$children获取子组件和父组件对象

　　　　　父组件代码：

 this.msg2=this.$children[0].msg
　　第三种方式:

　　　　　使用$ref获取指定的子组件

　　　　    父组件代码:

  <m-child v-bind:msg="p2C" @showMsg='getChild' ref='child'></m-child>
this.c2P=this.$refs.child.msg33
　　子组件向父组件传值

　　第一种方式:

　　　　　使用$emit传递事件给父组件，父组件监听该事件

　　　　   子组件代码　　　   

复制代码
<button @click="pushMsg()"></button>
methods: {
    pushMsg() {
      this.$emit("showMsg", "这是子组件===>父组件的值");
    }
  },
复制代码
　　　　  父组件代码

复制代码
<m-child v-bind:msg="p2C" @showMsg='getChild' ref='child'></m-child>
  methods: {
        getChild(val) {
            this.msg=val
        },
}
复制代码
　　第二种方式:

　　　　 使用$parent.获取父组件对象，然后再获取数据对象

 　　　　子组件代码

  mounted() {
    this.msg22 = this.$parent.msg2;
  }
　　　　　　　　

二.非父子组件间传值

　　1.事件总线

　　　　原理上就是建⽴立⼀一个公共的js⽂文件，专⻔门⽤用来传递消息

　　　　bus.js

import Vue from 'vue'
export default new Vue
　　　　在需要传递消息的地⽅方引⼊入

复制代码
mport bus from './util/bus'
methods: {
  passMsg () {
    bus.$emit('msg', 'i am from app')
  }
},
复制代码
　　　   传递消息，在需要接受消息的地方使用bus.$on接受消息

mounted () {
    bus.$on('msg', (val) => {
      this.childMsg = val
    });
 

　　2.$sttrs/listeners 用于多级组件间传值的问题

　　　　 解决多级组件间传值的问题
　　　　 $attr 将⽗父组件中不不包含props的属性传⼊入⼦子组件，通常配合 interitAttrs 选项

　　　　组件A传递到组件C,使用组件B作为桥梁A-B-C


组件A
<template>
  <div id="app">
    <!-- this is app -->
    <m-parent :msg="a" :msgb="b" :msgc="c"></m-parent>
  </div>
</template>
复制代码
　　　  组件B

<template>
  <div>
    <m-child  v-bind="$attrs"></m-child>
  </div>
</template>
　　　 组件C    注意：如果组件C中有props属性接受的对象的化，组件A传递的对象就会被自动过滤掉

复制代码
props: {
  msg: {
    type: String,
    default: ''
  },
}
　mounted () {
    console.log('attrs',this.$attrs)
  }
