import router from '@ohos.router';

export interface Params{
        click: (value: string) => void
}

@Component

export struct OptionsPicker{
        @Prop name: string;
        @Prop options: Array<string> = [];
        @State value: string = "";

        @Prop onButtonClick: Params;
        private select: number = 1
        aboutToAppear(): void {
                console.log("hi213")
                this.value = this.options[0];
        }




        build() {
                Row(){
                        TextPicker({range: this.options, selected: this.select})
                                .onChange((value: string | string[], index: number | number[]) => {
                                        this.onButtonClick.click(value as string)
                                        console.log(value as string)
                                }).divider({strokeWidth: "2px"})
                                .disappearTextStyle({color: "#ffffff"})
                                .selectedTextStyle({color: "#ffffff"}).canLoop(false)

                }.width("100%").backgroundColor('#676666').justifyContent(FlexAlign.Center)


        }
}