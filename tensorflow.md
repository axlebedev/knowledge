# TensorFlow

TensorFlow состоит из 3 основных частей:
1. Tensors
2. Operations
3. Models/Layers

## Tensors

Можно подать плоский массив и структуру тензора
```js
> const t1 = tf.tensor([1,2,3,4,2,4,6,8]), [2,4]);
< [[1,2,3,4], [2,4,6,8]]
```

Можно сразу структуру, без второго параметра
```js
> const t2 = tf.tensor([[1,2,3,4],[2,4,6,8]]);
< [[1,2,3,4], [2,4,6,8]]
```

Чтобы улучшить читаемость, ввели следующие функции:
- tf.scalar: Tensor with just one value
- tf.tensor1d: Tensor with one dimensions
- tf.tensor2d: Tensor with two dimensions
- tf.tensor3d: Tensor with three dimensions
- tf.tensor4d: Tensor with four dimensions

Есть крутая функция `tf.zeros`:
```js
> const t_zeros = tf.zeros([2,3]);
< [[0,0,0], [0,0,0]]
```

**In TensorFlow.js all tensors are immutable**

## Operations

By operations you can manipulate data of a tensor
```js
> const t3 = tf.tensor2d([1,2], [3, 4]);
> const t3_squared = t3.square();
> [[1, 4 ], [9, 16]]
```
