import { AvifDecoderTS, CjCacheCheckTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { CJReturnValue } from '@cangjie-tpc/avifhybrid/src/main/cangjie/types/libohos_app_cangjie_avif4hybrid/Index';
import { hilog } from '@kit.PerformanceAnalysisKit';






@Entry
@Component
struct page13Test {

  @State pixelMap1: PixelMap | undefined = undefined
  @State pixelMap2: PixelMap | undefined = undefined
  @State pixelMap3: PixelMap | undefined = undefined
  @State pixelMap4: PixelMap | undefined = undefined
  @State pixelMap5: PixelMap | undefined = undefined
  @State pixelMap6: PixelMap | undefined = undefined
  @State pixelMap7: PixelMap | undefined = undefined
  @State pixelMap8: PixelMap | undefined = undefined
  @State pixelMap9: PixelMap | undefined = undefined
  @State pixelMap10: PixelMap | undefined = undefined
  @State pixelMap11: PixelMap | undefined = undefined
  @State pixelMap12: PixelMap | undefined = undefined
  @State pixelMap13: PixelMap | undefined = undefined
  @State pixelMap14: PixelMap | undefined = undefined
  @State pixelMap15: PixelMap | undefined = undefined
  @State pixelMap16: PixelMap | undefined = undefined
  @State pixelMap17: PixelMap | undefined = undefined
  @State pixelMap18: PixelMap | undefined = undefined
  @State pixelMap19: PixelMap | undefined = undefined
  @State pixelMap20: PixelMap | undefined = undefined
  @State pixelMap21: PixelMap | undefined = undefined
  @State pixelMap22: PixelMap | undefined = undefined
  @State pixelMap23: PixelMap | undefined = undefined
  @State pixelMap24: PixelMap | undefined = undefined
  @State pixelMap25: PixelMap | undefined = undefined
  @State pixelMap26: PixelMap | undefined = undefined
  @State pixelMap27: PixelMap | undefined = undefined
  @State pixelMap28: PixelMap | undefined = undefined
  @State pixelMap29: PixelMap | undefined = undefined
  @State pixelMap30: PixelMap | undefined = undefined

  async createAvifPixelMap(url?: string): Promise<PixelMap|undefined> {
    if (!url) {
      return undefined
    }

    const decoderTs = new AvifDecoderTS()
    const decodeRes = await decoderTs.create(url)
    if (!decodeRes) {
      decoderTs.release()
      return undefined
    }

    const isAvifImageffi = decoderTs.isAvifImageffi()
    if (isAvifImageffi != 1) {
      decoderTs.release()
      return undefined
    }

    const width = decoderTs.getWidth()
    const height = decoderTs.getHeight()
    let cjreturnValue = await decoderTs.nextFrameffi(width, height)
    if (cjreturnValue == undefined
      || cjreturnValue == null
      || !cjreturnValue.issuccess) {
      decoderTs.release();
      return undefined;
    }
    let validReturnValue = cjreturnValue.color ?? new Uint8Array()
    let opts: image.InitializationOptions =
      { editable: true, pixelFormat: 3, size: { height: height, width: width } }
    const pixelMap = await image.createPixelMap(validReturnValue, opts)
    decoderTs.release()

    return pixelMap
  }


  url1 = 'https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif'
  url2 = 'https://pic7.inter.ptqy.gitv.tv/image/20230620/40/02/v_173008524_m_601_284_160.avif'
  url3 = 'https://pic8.iqiyipic.com/image/20250701/ac/18/a_100628502_m_601_m2_579_772.avif'
  url4 = 'https://m.inter.ptqy.gitv.tv/u4/image/20250214/18/3c/pv_7438183095956800_d_601_592_333.avif'
  url5 = 'https://pic2.inter.ptqy.gitv.tv/image/20211129/8d/7c/a_502637340006_d_705_402_556.avif'
  url6 = 'https://pic9.iqiyipic.com/image/20240920/e5/43/a_100517696_m_601_m35_720_405.avif'
  url7 = 'https://pic7.inter.ptqy.gitv.tv/image/20231120/8a/0a/v_174528982_m_601_480_270.avif'
  url8 = 'https://pic7.iqiyipic.com/image/20250616/7c/3a/v_181993728_m_601_579_772.avif'
  url9 = 'https://m.inter.ptqy.gitv.tv/u4/image/20250411/95/b9/pv_3885390556513500_d_601_284_160.avif'
  url10 = 'https://m.inter.ptqy.gitv.tv/u2/image/20241001/34/21/pv_8048631305885900_d_616_0_720.avif'
  url11 = 'https://pic8.iqiyipic.com/animated/20250806/3f/9e/5830642737316600_1754449128430_720_405.avif'
  url12 = 'https://pic3.iqiyipic.com/animated/20240214/9d/29/6955279253853500_1707880039133_592_333.avif'
  url13 = 'http://pic7.iqiyipic.com/animated/20250806/3b/1b/4816705105837600_1754459217014_592_333.avif'
  url14 = 'https://dx-pic6.iqiyipic.com/animated/20250722/61/cd/3079213879679200_1753185705381_592_333.avif'
  url15 = 'https://pic3.iqiyipic.com/animated/20250805/d7/17/3281359673308700_1754393441564_592_333.avif'
  url16 = 'https://pic4.iqiyipic.com/animated/20250716/32/9e/7442996091200700_1752635135587_592_333.avif'
  url17 = 'https://pic2.iqiyipic.com/animated/20250715/a6/8b/6241351651272300_1752580846633_592_333.avif'
  url18 = 'https://pic1.inter.ptqy.gitv.tv/animated/20250717/14/84/3170660786337100_1752720287778_480_270.avif'
  url19 = 'https://dx-pic2.iqiyipic.com/animated/20250712/fa/dc/6543768175923600_1752286242275_592_333.avif'
  url20 = 'https://dx-pic9.iqiyipic.com/animated/20250805/a0/77/5594003812234100_1754392241318_592_333.avif'
  url21 = 'https://pic5.iqiyipic.com/image/20250813/f3/3f/a_100630593_m_601_m1_579_772.avif'
  url22 = 'https://pic1.iqiyipic.com/image/20250328/04/74/a_100599720_m_601_m2_579_772.avif'
  url23 = 'https://pic8.iqiyipic.com/image/20250812/a4/24/a_100662810_m_601_m3_579_772.avif'
  url24 = 'https://pic8.iqiyipic.com/image/20250328/55/d9/a_100591204_m_601_m7_579_772.avif'
  url25 = 'https://pic9.iqiyipic.com/image/20250811/06/60/a_100657589_m_601_m3_579_772.avif'
  url26 = 'https://pic5.iqiyipic.com/image/20250801/63/23/a_100657688_m_601_m4_579_772.avif'
  url27 = 'https://pic1.iqiyipic.com/image/20250729/a6/e1/a_100652261_m_601_m10_579_772.avif'
  url28 = 'https://pic1.iqiyipic.com/image/20250728/a4/37/a_100659147_m_601_579_772.avif'
  url29 = 'https://pic6.iqiyipic.com/image/20250512/7b/44/a_100619995_m_601_m2_579_772.avif'
  url30 = 'https://pic3.iqiyipic.com/image/20250328/c5/13/a_100583545_m_601_m3_579_772.avif'


  // 'https://pic5.iqiyipic.com/image/20250813/f3/3f/a_100630593_m_601_m1_579_772.avif',
  // 'https://pic1.iqiyipic.com/image/20250328/04/74/a_100599720_m_601_m2_579_772.avif',
  // 'https://pic8.iqiyipic.com/image/20250812/a4/24/a_100662810_m_601_m3_579_772.avif',
  // 'https://pic8.iqiyipic.com/image/20250328/55/d9/a_100591204_m_601_m7_579_772.avif',
  // 'https://pic9.iqiyipic.com/image/20250811/06/60/a_100657589_m_601_m3_579_772.avif',
  // 'https://pic5.iqiyipic.com/image/20250801/63/23/a_100657688_m_601_m4_579_772.avif',
  // 'https://pic1.iqiyipic.com/image/20250729/a6/e1/a_100652261_m_601_m10_579_772.avif',
  // 'https://pic1.iqiyipic.com/image/20250728/a4/37/a_100659147_m_601_579_772.avif',
  // 'https://pic6.iqiyipic.com/image/20250512/7b/44/a_100619995_m_601_m2_579_772.avif',
  // 'https://pic3.iqiyipic.com/image/20250328/c5/13/a_100583545_m_601_m3_579_772.avif',
  // 'https://pic4.iqiyipic.com/image/20250330/25/fe/a_100609693_m_601_m2_579_772.avif',
  // 'https://pic2.iqiyipic.com/image/20250808/70/ad/a_100663406_m_601_579_772.avif',
  // 'https://pic1.iqiyipic.com/image/20250815/06/e3/a_100665407_m_601_579_772.avif',
  // 'https://pic3.iqiyipic.com/image/20250710/c4/b3/a_100630236_m_601_m1_579_772.avif',
  // 'https://pic1.iqiyipic.com/image/20250807/ac/27/a_100663074_m_601_579_772.avif',
  // 'https://pic3.iqiyipic.com/image/20250328/0f/aa/a_100579357_m_601_m2_579_772.avif',
  // 'https://pic5.iqiyipic.com/image/20250329/6d/8b/a_100604828_m_601_m3_579_772.avif',
  // 'https://pic1.iqiyipic.com/image/20250328/c3/61/a_100595634_m_601_m4_579_772.avif',
  // 'https://pic1.iqiyipic.com/image/20250728/e8/d7/a_100656872_m_601_m4_579_772.avif',
  // 'https://pic4.iqiyipic.com/image/20250808/97/79/a_100663163_m_601_m1_579_772.avif',


  async aboutToAppear(): Promise<void> {

    this.createAvifPixelMap(this.url1).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap1 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url2).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap2 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url3).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap3 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url4).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap4 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url5).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap5 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url6).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap6 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url7).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap7 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url8).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap8 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url9).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap9 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url10).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap10 = pixelMap
      }
    })

    this.createAvifPixelMap(this.url11).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap11 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url12).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap12 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url13).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap13 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url14).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap14 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url15).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap15 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url16).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap16 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url17).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap17 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url18).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap18 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url19).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap19 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url20).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap20 = pixelMap
      }
    })

    this.createAvifPixelMap(this.url21).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap21 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url22).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap22 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url23).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap23 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url24).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap24 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url25).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap25 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url26).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap26 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url27).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap27 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url28).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap28 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url29).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap29 = pixelMap
      }
    })
    this.createAvifPixelMap(this.url30).then((pixelMap)=> {
      if (pixelMap) {
        this.pixelMap30 = pixelMap
      }
    })

    // this.pixelMap1 = await this.createAvifPixelMap(this.url1)
    // this.pixelMap2 = await this.createAvifPixelMap(this.url2)
    // this.pixelMap3 = await this.createAvifPixelMap(this.url3)
    // this.pixelMap4 = await this.createAvifPixelMap(this.url4)
    // this.pixelMap5 = await this.createAvifPixelMap(this.url5)
    // this.pixelMap6 = await this.createAvifPixelMap(this.url6)
    // this.pixelMap7 = await this.createAvifPixelMap(this.url7)
    // this.pixelMap8 = await this.createAvifPixelMap(this.url8)
    // this.pixelMap9 = await this.createAvifPixelMap(this.url9)
    // this.pixelMap10 = await this.createAvifPixelMap(this.url10)
    // this.pixelMap11 = await this.createAvifPixelMap(this.url11)
    // this.pixelMap12 = await this.createAvifPixelMap(this.url12)
    // this.pixelMap13 = await this.createAvifPixelMap(this.url13)
    // this.pixelMap14 = await this.createAvifPixelMap(this.url14)
    // this.pixelMap15 = await this.createAvifPixelMap(this.url15)
    // this.pixelMap16 = await this.createAvifPixelMap(this.url16)
    // this.pixelMap17 = await this.createAvifPixelMap(this.url17)
    // this.pixelMap18 = await this.createAvifPixelMap(this.url18)
    // this.pixelMap19 = await this.createAvifPixelMap(this.url19)
    // this.pixelMap20 = await this.createAvifPixelMap(this.url20)
    // this.pixelMap21 = await this.createAvifPixelMap(this.url21)
    // this.pixelMap22 = await this.createAvifPixelMap(this.url22)
    // this.pixelMap23 = await this.createAvifPixelMap(this.url23)
    // this.pixelMap24 = await this.createAvifPixelMap(this.url24)
    // this.pixelMap25 = await this.createAvifPixelMap(this.url25)
    // this.pixelMap26 = await this.createAvifPixelMap(this.url26)
    // this.pixelMap27 = await this.createAvifPixelMap(this.url27)
    // this.pixelMap28 = await this.createAvifPixelMap(this.url28)
    // this.pixelMap29 = await this.createAvifPixelMap(this.url29)
    // this.pixelMap30 = await this.createAvifPixelMap(this.url30)
  }

  aboutToDisappear(): void {
    if(this.pixelMap1){
      this.pixelMap1.release()
    }
    if(this.pixelMap2){
      this.pixelMap2.release()
    }
    if(this.pixelMap3){
      this.pixelMap3.release()
    }
    if(this.pixelMap4){
      this.pixelMap4.release()
    }
    if(this.pixelMap5){
      this.pixelMap5.release()
    }
    if(this.pixelMap6){
      this.pixelMap6.release()
    }
    if(this.pixelMap7){
      this.pixelMap7.release()
    }
    if(this.pixelMap8){
      this.pixelMap8.release()
    }
    if(this.pixelMap9){
      this.pixelMap9.release()
    }
    if(this.pixelMap10){
      this.pixelMap10.release()
    }

    if(this.pixelMap11){
      this.pixelMap11.release()
    }
    if(this.pixelMap12){
      this.pixelMap12.release()
    }
    if(this.pixelMap13){
      this.pixelMap13.release()
    }
    if(this.pixelMap14){
      this.pixelMap14.release()
    }
    if(this.pixelMap15){
      this.pixelMap15.release()
    }
    if(this.pixelMap16){
      this.pixelMap16.release()
    }
    if(this.pixelMap17){
      this.pixelMap17.release()
    }
    if(this.pixelMap18){
      this.pixelMap18.release()
    }
    if(this.pixelMap19){
      this.pixelMap19.release()
    }
    if(this.pixelMap20){
      this.pixelMap20.release()
    }

    if(this.pixelMap21){
      this.pixelMap21.release()
    }
    if(this.pixelMap22){
      this.pixelMap22.release()
    }
    if(this.pixelMap23){
      this.pixelMap23.release()
    }
    if(this.pixelMap24){
      this.pixelMap24.release()
    }
    if(this.pixelMap25){
      this.pixelMap25.release()
    }
    if(this.pixelMap26){
      this.pixelMap26.release()
    }
    if(this.pixelMap27){
      this.pixelMap27.release()
    }
    if(this.pixelMap28){
      this.pixelMap28.release()
    }
    if(this.pixelMap29){
      this.pixelMap29.release()
    }
    if(this.pixelMap30){
      this.pixelMap30.release()
    }
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Image(this.pixelMap1)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap2)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap3)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap4)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap5)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap6)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap7)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap8)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap9)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap10)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap11)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap12)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap13)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap14)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap15)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap16)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap17)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap18)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap19)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap20)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap21)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap22)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap23)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap24)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap25)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap26)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap27)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap28)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap29)
            .objectFit(ImageFit.Fill)
          Image(this.pixelMap30)
            .objectFit(ImageFit.Fill)
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

