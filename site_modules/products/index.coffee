import Router from 'koa-router'


productsRouter = new Router()

productsRouter.get 'products', '/', (ctx, next) =>
  productNames = [
    'ASUS X542BA-DH99'
    'iSmart SMTB4002 N14H Pro-R'
    'ASUS VivoBook E403NA-US21'
    'ASUS Vivobook S S510UA-DS71'
    'ASUS R541NA-RS01 Notebook'
    'ASUS ZenPad 8'
    'ASUS Transformer Book T101HA-C4-GR'
    'ASUS Zenpad Z500M-C1-SL'
    'Lenovo ThinkPad E570'
    'Acer (Refurbished) Aspire A315-21-99E5'
    'ASUS F542UA-DH71'
    'Acer (Refurbished) Swift SF314-52-53AX'
    'ASUS Transformer Mini T102HA-D4-GR'
    'Lenovo Thinkpad T440'
    'ASUS VivoBook X540UA-DH31'
    'HP(Refurbished) 210 G1'
    'iSmart SMTB4100'
    'ASUS ZenBook UX430UQ-Q72SP-CB'
    'Acer Swift 3 SF314-52-55HL'
    'Acer (Refurbished) Spin 3 SP315-51-598W'
  ]
  products = []
  buildProd = (name) ->
    price = Math.round(((Math.random() * 2300) + 300) * 100) / 100
    newProd =
      name: name
      price: price
    products.push newProd
  buildProd name for name in productNames
  console.log 'in products route'
  console.log products
  ctx.render 'products/list', { title: 'Products', products: products }, true


export { productsRouter }
