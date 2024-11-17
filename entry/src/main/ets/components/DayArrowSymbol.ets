import router from '@ohos.router';


@Component

export struct DayArrowSymbol{
        @Prop day: number
        @Prop sizeOfSymbolHeight : string
        @Prop sizeOfSymbolWidth : string
        @Prop sizeOfFont : number

        @State angle : number = 270

        aboutToAppear(): void {

                if(this.day < 0){
                        this.angle = 90
                }

        }

        build() {

                Row(){
                        Text(this.day.toString())
                                .fontSize(this.sizeOfFont)

                                .fontColor("#ffffff")
                        Column(){
                                Image($r('app.media.arrow'))
                                        .fillColor(Color.White).rotate({angle: this.angle})
                                        .height(this.sizeOfSymbolHeight).width(this.sizeOfSymbolWidth)
                        }
                        .justifyContent(FlexAlign.Center)
                        .alignItems(HorizontalAlign.Start).margin({ top: '-8%' })
                }.height("100%")



        }
}