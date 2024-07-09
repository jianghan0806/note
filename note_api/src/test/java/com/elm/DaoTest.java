package com.elm;

import com.elm.dao.IBusinessDao;
import com.elm.pojo.Business;
import com.elm.pojo.Food;
import com.elm.pojo.Orders;
import jakarta.annotation.Resource;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Commit;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@SpringBootTest
public class DaoTest {
    @Resource
    public IBusinessDao busDao;

    @Test
    @Transactional
    @Commit
    public void insertBusiness(){
        Business bus =new Business();
        bus.setBusinessId(3);
        bus.setBusinessName("麦当劳3");
        bus.setBusinessAddress("这是一个地址3");
        bus.setBusinessExplain("我们家配送费便宜3");
        bus.setDeliveryPrice(10.0);

        Food food= new Food();
        food.setFoodId(2);
        food.setFoodName("麦辣鸡腿堡3");
        food.setFoodPrice(15.0);
        bus.getFoodList().add(food);

        busDao.save(bus);

        System.out.println("");
    }
    @Test
    @Transactional
    @Commit
    public void deleteBusiness(){
        busDao.deleteById(2);
    }
    @Test
    @Transactional
    @Commit
    public void updateBusiness(){
        Optional<Business> busInfo =busDao.findById(3);
        if(busInfo.isPresent()){
            Business buss = busInfo.get();
            buss.getFoodList().get(0).setFoodPrice(20.0);
            busDao.save(buss);
        }

    }
    @Test
    @Transactional
    @Commit
    public void findBusiness(){
        Optional<Business> busInfo =busDao.findById(2);
        if(busInfo.isPresent()){
            Business buss = busInfo.get();
            List<Food> foodList = buss.getFoodList();
            System.out.println("");
        }
    }
    @Test
    @Transactional
    @Commit
    public void findBusinessByName(){
        List<Business> busList =busDao.findBusinessesByBusinessNameContaining("麦");
        System.out.println("");
    }
    @Test
    @Transactional
    @Commit
    public void findBusinessByNameAndAddress(){
        List<Business> busList =busDao.findBusinessesByBusinessNameContainingAndBusinessAddressContaining("麦","地");
        System.out.println("");
    }
}
