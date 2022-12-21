import { App } from "../lib/app.ts";

export interface Provider {
    detect(app: App): boolean;
}