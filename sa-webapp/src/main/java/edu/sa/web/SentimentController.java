package edu.sa.web;

import edu.sa.web.dto.SentenceDto;
import edu.sa.web.dto.SentimentDto;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@CrossOrigin(origins = "*")
@RestController
public class SentimentController {

    private static final Logger logger = LoggerFactory.getLogger(SentimentController.class);

    @Value("${sa.logic.api.url}")
    private String saLogicApiUrl;

    @PostMapping("/sentiment")
    public SentimentDto sentimentAnalysis(@RequestBody SentenceDto sentenceDto) {
         System.out.println("Hello from Java called from React");
        logger.info("saLogicApiUrl: " + saLogicApiUrl);
        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.postForEntity(saLogicApiUrl + "/analyse/sentiment",
                sentenceDto, SentimentDto.class).getBody();
    }

    @GetMapping("/analyse")
    public String analyseSentimentGet() {
        logger.info("saLogicApiUrl: " + saLogicApiUrl);
        RestTemplate restTemplate = new RestTemplate();
        String result = restTemplate.getForObject(saLogicApiUrl + "/analyse?sentence=i+am+not+happy", String.class);
        return result;
    }

    @GetMapping("/testHealth")
    public String testHealth() {
        return "hello from SpringBoot webapp!!";
    }

    @GetMapping("/testComms")
    public String testComms() {
        logger.info("saLogicApiUrl: " + saLogicApiUrl);
        RestTemplate restTemplate = new RestTemplate();
        String result = restTemplate.getForObject(saLogicApiUrl + "/testHealth", String.class);
        return result;
    }


    @GetMapping("/testFromReact")
    public String testReact() {
       
        
        return "hello";
    }

    
    
}
