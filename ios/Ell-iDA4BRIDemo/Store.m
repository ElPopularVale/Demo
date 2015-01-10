//
//  Store.m
//  Ell-iDA4BRIDemo
//
//  Created by Jose Granados on 30/11/14.
//  Copyright (c) 2014 Jose Granados. All rights reserved.
//

#import "Store.h"
#import "Product.h"
#import "Mannequin.h"

@implementation Store

- (id)init
{
    self = [super init];
    if (self) {
        
        Product *ahto = [[Product alloc] init];
        Product *hali = [[Product alloc] init];
        Product *kaivopuisto = [[Product alloc] init];
        Product *kuura = [[Product alloc] init];
        Product *vallila = [[Product alloc] init];
        Product *olkakierto = [[Product alloc] init];
        Product *peace = [[Product alloc] init];
        Product *rokka = [[Product alloc] init];
        Product *sysi = [[Product alloc] init];
        Product *taikina = [[Product alloc] init];
        Product *ullanlinna = [[Product alloc] init];
        
        Mannequin *mannequinAhto = [[Mannequin alloc] init];
        Mannequin *mannequinVallila = [[Mannequin alloc] init];
        Mannequin *mannequinRokka = [[Mannequin alloc] init];
        
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
//        UIImage *imagejose = [UIImage imageWithContentsOfFile:filePath];
        
        ahto.productName = @"Ahto";
        ahto.productPrice = 299.0f;
        ahto.productImage = [UIImage imageNamed:@"DemoImages/ahto.jpg"];
        ahto.isInStock = YES;
        ahto.isInteresting = YES;
        ahto.productSize = @"M";
        ahto.productDescription = @"The Ahto winter parka is made of brown army sleeping bag. The material that's seen and experienced a lot can now continue its life as a warm winter jacket with the original buttoning from the sleeping bag. The front of the jacket has a hidden zipper. The pockets have been taken off a Swedish army jacket. There's a draw string at the waist and the cuffs have jersey ribbing. This jacket is a part of the menswear collection designed by Anssi Tuupainen.";
        
        hali.productName = @"Hali";
        hali.productPrice = 28.0f;
        hali.productImage = [UIImage imageNamed:@"DemoImages/hali.jpg"];
        hali.productDescription = @"The Hali scarves are made of old Swedish army scarves. The thin but warm scarf materials have now been sewn into a series of long scarves that have hand-crocheted vintage lace decorations at the tips.";
        
        kuura.productName = @"Kuura";
        kuura.productPrice = 98.0f;
        kuura.productImage = [UIImage imageNamed:@"DemoImages/kuura.jpg"];
        kuura.productDescription = @"The Kuura bag is made of an army tent raincover. The canvas bag has a large pocket split in two on its side. The bag has adjustable handles and shoulder strap. The bag is lined and has a small inside pocket. This bag is a part of the menswear collection designed by Anssi Tuupainen.";
        
        olkakierto.productName = @"Olkakierto";
        olkakierto.productPrice = 172.5f;
        olkakierto.productImage = [UIImage imageNamed:@"DemoImages/olkakierto.jpg"];
        olkakierto.productDescription = @"Here's a stylish choice for a latop bag! This laptop bag is made of recycled seatbelts sewn together. The inside of the bag is lined with quilted vintage fabric. The buckles of the detachable strap used to hold an airplane seatbelt in place! The bag is available in three different sizes.";
        
        peace.productName = @"Peace";
        peace.productPrice = 65.0f;
        peace.productImage = [UIImage imageNamed:@"DemoImages/peace.jpg"];
        peace.productDescription = @"I was born in the Soviet Union in the 50's but abandoned as dead stock for years. Instead of becoming a mattress cover years ago I've now been made into a lovely blouse. A miracle brought me to life again and this new life, oh, it's glorious! My collar and cuffs have been toughened up with either army sack or a deadstock fabric. My loose style fits any body type beautifully and my material is nice and flowy.";
        
        rokka.productName = @"Rokka";
        rokka.productPrice = 295.0f;
        rokka.productImage = [UIImage imageNamed:@"DemoImages/rokka.jpg"];
        rokka.productDescription = @"What a change! Covering tents in my previous job, I also used to look like one. Now I'm totally transformed! With my elastic inner cuffs the faux fur lining the edge of my hood, I'll keep you covered from the snowfall, winter winds and flurries. You can tighten the waistline with my belt to keep the frost out. I'm made of an army tent cover, a heavy duty army canvas - you may see my old seams here and there - with original metallic army buttons. I will keep you looking stylish and warm, just like a classic parka should!";
        
        sysi.productName = @"Sysi";
        sysi.productPrice = 153.0f;
        sysi.productImage = [UIImage imageNamed:@"DemoImages/sysi.jpg"];
        sysi.productDescription = @"The Sysi pants are made of army tent raincover canvas. The trousers have pockets that used to be on a Swedish army jacket. The originally grey material of these slim pants has been dyed into a stylish black. These trousers are a part of the menswear collection designed by Anssi Tuupainen.";
        
        taikina.productName = @"Taikina";
        taikina.productPrice = 125.0f;
        taikina.productImage = [UIImage imageNamed:@"DemoImages/taikina.jpg"];
        taikina.productDescription = @"The Taikina bag is made of a heavy cotton army utility sack that's been dyed black. The mouth of the bag has a grandma’s purse clip mechanism that flops onto the side. The bag has a zip-up pocket on the side. The bag has an adjustable shoulder strap and is lined with stripey or floral vintage fabric.";
        
        ullanlinna.productName = @"Ullanlinna";
        ullanlinna.productPrice = 285.0f;
        ullanlinna.productImage = [UIImage imageNamed:@"DemoImages/ullanlinna.jpg"];
        ullanlinna.productDescription = @"Before this job I worked in the Swedish army covering tents. Oh, those weathers and memories! These pockets of mine I got of an old jacket, which used be part of a Swedish army summer uniform. The fabrics were dyed black, on which all the great metal details, buttons and hoops, shine out quietly but brightly - like the light seams, too! ";
        
        vallila.productName = @"Vallila";
        vallila.productPrice = 118.0f;
        vallila.productImage = [UIImage imageNamed:@"DemoImages/vallila.jpg"];
        vallila.isInteresting = YES;
        vallila.isInStock = YES;
        vallila.productSize = @"M";
        vallila.productDescription = @"Hey, man! You seem like a great jack. Let's go for a pint sometime! As a former unemployed peat yarn I'm a good listener but I've also got stories to tell. There's a bit of wool in the yarn of mine too; the knit is black and beige melange. My hem has been finished with a drawstring and my collar warms high!";
        
        self.productArray = [NSMutableArray arrayWithObjects: ahto, vallila, hali, kuura, olkakierto, peace, rokka, sysi, taikina, ullanlinna, nil];
        mannequinAhto.name = @"Ahto";
        mannequinAhto.setOfProducts = [NSMutableArray arrayWithObjects:olkakierto, ahto, sysi, nil];
        mannequinVallila.name = @"Vallila";
        mannequinVallila.setOfProducts = [NSMutableArray arrayWithObjects:kuura, vallila, ullanlinna, sysi, nil];
        mannequinRokka.name = @"Rokka";
        mannequinRokka.setOfProducts = [NSMutableArray arrayWithObjects:hali, peace, taikina, rokka, nil];
        
        self.mannequinArray = [NSMutableArray arrayWithObjects:mannequinAhto, mannequinVallila, mannequinRokka, nil];
        
        self.highlightedProductsArray = [NSMutableArray arrayWithObjects:ahto, vallila, rokka, nil];
        
    }
    return self;
}
@end
